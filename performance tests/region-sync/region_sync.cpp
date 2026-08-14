// What a `region class` costs per allocation, under each way of making it thread-safe.
//
// A region class is ONE region per type for the whole program, so every thread allocating an A hits
// the same allocator. Today's regions need no synchronization at all because each one is owned by an
// object and inherits its owner's thread. This measures what we would be adding.
//
// The hot path mirrored below is `__polaron_region_new`'s, for the homogeneous case a region class
// always is: pop a same-size free slot if there is one, otherwise bump the cursor. That is a handful
// of instructions, which is exactly why the question matters -- an uncontended mutex can cost more
// than the allocation it protects.
//
// Four strategies, because the obvious two are not the only two:
//   NoSync      the floor: what a region costs today, single-threaded
//   Mutexed     one std::mutex around the whole path
//   Spun        an atomic_flag spinlock -- short critical sections often prefer this
//   AtomicBump  no lock at all: fetch_add on the cursor, and a per-thread free list
//
// AtomicBump is the interesting one. Bump allocation is atomically composable on its own; only the
// free list needs care, and a free list does not have to be shared.
//
// Build (from this directory), inside vcvars64:
//   cl /std:c++17 /O2 /EHsc region_sync.cpp
//   ./region_sync.exe

#include <atomic>
#include <chrono>
#include <cstdint>
#include <cstdio>
#include <memory>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

namespace {

constexpr std::size_t kHeaderBytes = 16;   // PolaronHdr, as in polaron_region_core.hpp
constexpr std::size_t kPayload     = 32;   // a plausible node: a value and two links
constexpr std::size_t kSlotBytes   = kHeaderBytes + kPayload;

// The storage a region hands slots out of. Deliberately dumb: this measures the SYNCHRONIZATION,
// so every strategy below allocates out of the same shape of memory and differs only in how it
// guards the cursor.
class Slab {
public:
    explicit Slab(std::size_t slots) : bytes_(slots * kSlotBytes), base_(new char[bytes_]) {}
    char*       base()  const { return base_.get(); }
    std::size_t bytes() const { return bytes_; }

private:
    std::size_t             bytes_;
    std::unique_ptr<char[]> base_;
};

// One free slot, threaded through the payload of the slot it describes -- the real allocator does
// exactly this, which is why a free list costs no extra memory.
struct FreeNode {
    FreeNode* next;
};

// ---- The strategies. Each exposes allocate()/release(void*), and nothing else. ----

class NoSync {
public:
    explicit NoSync(std::size_t slots) : slab_(slots) {}
    void* allocate() {
        if (free_ != nullptr) { FreeNode* n = free_; free_ = n->next; return n; }
        char* p = slab_.base() + used_;
        used_ += kSlotBytes;
        return p + kHeaderBytes;
    }
    void release(void* p) {
        FreeNode* n = static_cast<FreeNode*>(p);
        n->next = free_;
        free_ = n;
    }

private:
    Slab        slab_;
    std::size_t used_ = 0;
    FreeNode*   free_ = nullptr;
};

class Mutexed {
public:
    explicit Mutexed(std::size_t slots) : slab_(slots) {}
    void* allocate() {
        std::lock_guard<std::mutex> guard(mu_);
        if (free_ != nullptr) { FreeNode* n = free_; free_ = n->next; return n; }
        char* p = slab_.base() + used_;
        used_ += kSlotBytes;
        return p + kHeaderBytes;
    }
    void release(void* p) {
        std::lock_guard<std::mutex> guard(mu_);
        FreeNode* n = static_cast<FreeNode*>(p);
        n->next = free_;
        free_ = n;
    }

private:
    Slab        slab_;
    std::mutex  mu_;
    std::size_t used_ = 0;
    FreeNode*   free_ = nullptr;
};

class Spun {
public:
    explicit Spun(std::size_t slots) : slab_(slots) {}
    void* allocate() {
        Guard guard(flag_);
        if (free_ != nullptr) { FreeNode* n = free_; free_ = n->next; return n; }
        char* p = slab_.base() + used_;
        used_ += kSlotBytes;
        return p + kHeaderBytes;
    }
    void release(void* p) {
        Guard guard(flag_);
        FreeNode* n = static_cast<FreeNode*>(p);
        n->next = free_;
        free_ = n;
    }

private:
    class Guard {
    public:
        explicit Guard(std::atomic_flag& f) : f_(f) {
            while (f_.test_and_set(std::memory_order_acquire)) { /* spin */ }
        }
        ~Guard() { f_.clear(std::memory_order_release); }
        Guard(const Guard&) = delete;
        Guard& operator=(const Guard&) = delete;

    private:
        std::atomic_flag& f_;
    };

    Slab             slab_;
    std::atomic_flag flag_ = ATOMIC_FLAG_INIT;
    std::size_t      used_ = 0;
    FreeNode*        free_ = nullptr;
};

// No lock anywhere. The cursor is a single fetch_add, which hands every thread a distinct slot; the
// free list is thread_local, so a freed slot returns to the thread that freed it and contends with
// nobody. The trade is that a slot freed on thread A is reused only by thread A.
class AtomicBump {
public:
    explicit AtomicBump(std::size_t slots) : slab_(slots) {}
    void* allocate() {
        FreeNode*& mine = localFree();
        if (mine != nullptr) { FreeNode* n = mine; mine = n->next; return n; }
        std::size_t off = used_.fetch_add(kSlotBytes, std::memory_order_relaxed);
        return slab_.base() + off + kHeaderBytes;
    }
    void release(void* p) {
        FreeNode*& mine = localFree();
        FreeNode* n = static_cast<FreeNode*>(p);
        n->next = mine;
        mine = n;
    }

private:
    static FreeNode*& localFree() {
        static thread_local FreeNode* head = nullptr;
        return head;
    }
    Slab                     slab_;
    std::atomic<std::size_t> used_{0};
};

// The same idea as AtomicBump, with the one change the numbers ask for: a thread does not take the
// cursor per object, it takes a RUN of slots and hands them out locally. One atomic per kRun
// allocations instead of one per allocation, and the region still has a single contiguous address
// space -- which is what keeps a slot index a single number, and an iteration a single linear scan.
class ChunkedBump {
public:
    explicit ChunkedBump(std::size_t slots) : slab_(slots) {}

    void* allocate() {
        Local& me = local();
        if (me.free != nullptr) { FreeNode* n = me.free; me.free = n->next; return n; }
        if (me.remaining == 0) {
            me.cursor    = used_.fetch_add(kRun * kSlotBytes, std::memory_order_relaxed);
            me.remaining = kRun;
        }
        const std::size_t off = me.cursor;
        me.cursor += kSlotBytes;
        --me.remaining;
        return slab_.base() + off + kHeaderBytes;
    }

    void release(void* p) {
        Local& me = local();
        FreeNode* n = static_cast<FreeNode*>(p);
        n->next = me.free;
        me.free = n;
    }

private:
    static constexpr std::size_t kRun = 64;
    struct Local {
        FreeNode*   free      = nullptr;
        std::size_t cursor    = 0;
        std::size_t remaining = 0;
    };
    static Local& local() {
        static thread_local Local me;
        return me;
    }
    Slab                     slab_;
    std::atomic<std::size_t> used_{0};
};

// ---- Harness ----

// Two workloads, because they stress different halves of the allocator:
//   Grow  -- allocate and never free. A loading phase; pure cursor, no free list.
//   Churn -- allocate and free in a rolling window. Steady state; the free list carries the traffic.
enum class Load { Grow, Churn };

constexpr std::size_t kOpsPerThread = 2'000'000;
constexpr std::size_t kWindow       = 64;

template <typename Allocator>
double runOnce(Load load, unsigned threads, std::size_t slotsPerThread) {
    Allocator alloc(slotsPerThread * threads + kWindow * threads + 64);
    std::atomic<unsigned> ready{0};
    std::atomic<bool>     go{false};

    auto body = [&]() {
        ready.fetch_add(1, std::memory_order_release);
        while (!go.load(std::memory_order_acquire)) { /* line up, so the clock covers the contention */ }
        if (load == Load::Grow) {
            for (std::size_t i = 0; i < kOpsPerThread; ++i) {
                void* p = alloc.allocate();
                *static_cast<volatile char*>(p) = 1;   // touch it; an untouched allocation is not one
            }
        } else {
            std::vector<void*> live;
            live.reserve(kWindow);
            for (std::size_t i = 0; i < kWindow; ++i) live.push_back(alloc.allocate());
            for (std::size_t i = 0; i < kOpsPerThread; ++i) {
                std::size_t slot = i % kWindow;
                alloc.release(live[slot]);
                live[slot] = alloc.allocate();
                *static_cast<volatile char*>(live[slot]) = 1;
            }
            for (void* p : live) alloc.release(p);
        }
    };

    std::vector<std::thread> pool;
    pool.reserve(threads);
    for (unsigned t = 0; t < threads; ++t) pool.emplace_back(body);
    while (ready.load(std::memory_order_acquire) < threads) { /* wait for every thread to exist */ }

    const auto start = std::chrono::steady_clock::now();
    go.store(true, std::memory_order_release);
    for (auto& th : pool) th.join();
    const auto stop = std::chrono::steady_clock::now();

    const double ns = std::chrono::duration<double, std::nano>(stop - start).count();
    return ns / static_cast<double>(kOpsPerThread * threads);   // ns per allocation
}

// Per-thread subpools: T independent allocators, one per thread, no sharing at all. This is the
// design alternative to locking, so it is measured the same way rather than argued about.
double runSubpools(Load load, unsigned threads) {
    std::vector<std::unique_ptr<NoSync>> allocs;
    allocs.reserve(threads);
    for (unsigned t = 0; t < threads; ++t)
        allocs.push_back(std::make_unique<NoSync>(kOpsPerThread + kWindow + 64));

    std::atomic<unsigned> ready{0};
    std::atomic<bool>     go{false};

    auto body = [&](unsigned id) {
        NoSync& alloc = *allocs[id];
        ready.fetch_add(1, std::memory_order_release);
        while (!go.load(std::memory_order_acquire)) { }
        if (load == Load::Grow) {
            for (std::size_t i = 0; i < kOpsPerThread; ++i) {
                void* p = alloc.allocate();
                *static_cast<volatile char*>(p) = 1;
            }
        } else {
            std::vector<void*> live;
            live.reserve(kWindow);
            for (std::size_t i = 0; i < kWindow; ++i) live.push_back(alloc.allocate());
            for (std::size_t i = 0; i < kOpsPerThread; ++i) {
                std::size_t slot = i % kWindow;
                alloc.release(live[slot]);
                live[slot] = alloc.allocate();
                *static_cast<volatile char*>(live[slot]) = 1;
            }
        }
    };

    std::vector<std::thread> pool;
    pool.reserve(threads);
    for (unsigned t = 0; t < threads; ++t) pool.emplace_back(body, t);
    while (ready.load(std::memory_order_acquire) < threads) { }

    const auto start = std::chrono::steady_clock::now();
    go.store(true, std::memory_order_release);
    for (auto& th : pool) th.join();
    const auto stop = std::chrono::steady_clock::now();

    const double ns = std::chrono::duration<double, std::nano>(stop - start).count();
    return ns / static_cast<double>(kOpsPerThread * threads);
}

// Three runs, middle one reported. This machine's timings drift with temperature, and a single
// reading has already produced one fake result in this project.
template <typename F>
double median3(F&& f) {
    double a = f(), b = f(), c = f();
    if (a > b) std::swap(a, b);
    if (b > c) std::swap(b, c);
    if (a > b) std::swap(a, b);
    return b;
}

void report(const char* load, unsigned threads, double noSync, double subpool,
            double mutexed, double spun, double atomicBump, double chunked) {
    std::printf("%-6s %3u   %8.2f %8.2f %8.2f %8.2f %8.2f %8.2f\n",
                load, threads, noSync, subpool, mutexed, spun, atomicBump, chunked);
}

}  // namespace

int main() {
    const unsigned hw = std::thread::hardware_concurrency();
    std::printf("cores: %u,  %llu ops/thread,  slot = %llu bytes\n\n",
                hw, static_cast<unsigned long long>(kOpsPerThread),
                static_cast<unsigned long long>(kSlotBytes));
    std::printf("ns per allocation (lower is better)\n");
    std::printf("load   thr    nosync  subpool   mutex     spin   atomic  chunked\n");

    const unsigned counts[] = {1, 2, 4, 8, 16};
    for (Load load : {Load::Grow, Load::Churn}) {
        const char* name = (load == Load::Grow) ? "grow" : "churn";
        for (unsigned t : counts) {
            if (t > hw) continue;
            const std::size_t slots = kOpsPerThread + kWindow + 64;
            const double noSync = (t == 1) ? median3([&] { return runOnce<NoSync>(load, 1, slots); }) : 0.0;
            const double subp   = median3([&] { return runSubpools(load, t); });
            const double mtx    = median3([&] { return runOnce<Mutexed>(load, t, slots); });
            const double spin   = median3([&] { return runOnce<Spun>(load, t, slots); });
            const double atom   = median3([&] { return runOnce<AtomicBump>(load, t, slots); });
            const double chunk  = median3([&] { return runOnce<ChunkedBump>(load, t, slots); });
            report(name, t, noSync, subp, mtx, spin, atom, chunk);
        }
        std::printf("\n");
    }
    std::printf("nosync is the floor and is single-threaded only: it is what a region costs today.\n");
    return 0;
}
