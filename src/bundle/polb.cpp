#include "bundle/polb.h"

#include <algorithm>
#include <cstring>

namespace polaron {
namespace {

// The container's own name, on disk. Each of the language's old names took its magic with it --
// `LDB\x01`, then `INGB` -- because nothing reads the old ones, and a stale bundle must be rejected
// by the magic rather than misread by a newer loader. The magic is written as characters and so is
// invisible to every rename that works on identifiers; both times it had to be changed by hand.
constexpr char kMagic[4] = {'P', 'O', 'L', 'B'};
// 2: the header gained the ABI revision and the producer string. A version-1 container is refused
// rather than read, because from the inserted field onward its bytes no longer mean what they meant.
constexpr std::uint16_t kFormatVersion = 2;

// A self-contained SHA-256 (FIPS 180-4). The .polb container has no LLVM dependency, so the format
// library links into both the compiler and the (LLVM-free) runtime loader. Verified by a
// known-answer test in the unit suite.
struct Sha256 {
    std::uint32_t h[8] = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
                          0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19};
    std::uint64_t total = 0;
    std::uint8_t buf[64];
    std::size_t bufLen = 0;

    static std::uint32_t rotr(std::uint32_t x, std::uint32_t n) { return (x >> n) | (x << (32 - n)); }

    void block(const std::uint8_t* p) {
        static const std::uint32_t k[64] = {
            0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4,
            0xab1c5ed5, 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe,
            0x9bdc06a7, 0xc19bf174, 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f,
            0x4a7484aa, 0x5cb0a9dc, 0x76f988da, 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
            0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967, 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc,
            0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85, 0xa2bfe8a1, 0xa81a664b,
            0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070, 0x19a4c116,
            0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
            0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7,
            0xc67178f2};
        std::uint32_t w[64];
        for (int i = 0; i < 16; ++i) {
            w[i] = (std::uint32_t(p[i * 4]) << 24) | (std::uint32_t(p[i * 4 + 1]) << 16) |
                   (std::uint32_t(p[i * 4 + 2]) << 8) | std::uint32_t(p[i * 4 + 3]);
        }
        for (int i = 16; i < 64; ++i) {
            std::uint32_t s0 = rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >> 3);
            std::uint32_t s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >> 10);
            w[i] = w[i - 16] + s0 + w[i - 7] + s1;
        }
        std::uint32_t a = h[0], b = h[1], c = h[2], d = h[3], e = h[4], f = h[5], g = h[6], hh = h[7];
        for (int i = 0; i < 64; ++i) {
            std::uint32_t S1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
            std::uint32_t ch = (e & f) ^ (~e & g);
            std::uint32_t t1 = hh + S1 + ch + k[i] + w[i];
            std::uint32_t S0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
            std::uint32_t maj = (a & b) ^ (a & c) ^ (b & c);
            std::uint32_t t2 = S0 + maj;
            hh = g; g = f; f = e; e = d + t1; d = c; c = b; b = a; a = t1 + t2;
        }
        h[0] += a; h[1] += b; h[2] += c; h[3] += d; h[4] += e; h[5] += f; h[6] += g; h[7] += hh;
    }

    void update(const std::uint8_t* p, std::size_t n) {
        total += n;
        while (n > 0) {
            const std::size_t take = std::min(n, std::size_t(64) - bufLen);
            std::memcpy(buf + bufLen, p, take);
            bufLen += take;
            p += take;
            n -= take;
            if (bufLen == 64) {
                block(buf);
                bufLen = 0;
            }
        }
    }

    std::array<std::uint8_t, 32> final() {
        const std::uint64_t bits = total * 8;
        const std::uint8_t one = 0x80;
        update(&one, 1);
        const std::uint8_t zero = 0;
        while (bufLen != 56) {
            update(&zero, 1);
        }
        std::uint8_t lenBytes[8];
        for (int i = 0; i < 8; ++i) {
            lenBytes[i] = std::uint8_t(bits >> (56 - i * 8));
        }
        update(lenBytes, 8);
        std::array<std::uint8_t, 32> out{};
        for (int i = 0; i < 8; ++i) {
            out[i * 4] = std::uint8_t(h[i] >> 24);
            out[i * 4 + 1] = std::uint8_t(h[i] >> 16);
            out[i * 4 + 2] = std::uint8_t(h[i] >> 8);
            out[i * 4 + 3] = std::uint8_t(h[i]);
        }
        return out;
    }
};

void putU16(std::string& out, std::uint16_t v) {
    out.push_back(static_cast<char>(v & 0xFF));
    out.push_back(static_cast<char>((v >> 8) & 0xFF));
}
void putU32(std::string& out, std::uint32_t v) {
    for (int i = 0; i < 4; ++i) {
        out.push_back(static_cast<char>((v >> (8 * i)) & 0xFF));
    }
}
void putStr16(std::string& out, std::string_view s) {  // u16 length prefix
    putU16(out, static_cast<std::uint16_t>(s.size()));
    out.append(s);
}
void putStr32(std::string& out, std::string_view s) {  // u32 length prefix
    putU32(out, static_cast<std::uint32_t>(s.size()));
    out.append(s);
}

// A bounds-checked cursor over the byte buffer; sets `ok=false` on any short read.
struct Reader {
    std::string_view b;
    std::size_t pos = 0;
    bool ok = true;
    std::uint16_t u16() {
        if (pos + 2 > b.size()) { ok = false; return 0; }
        std::uint16_t v = static_cast<std::uint8_t>(b[pos]) |
                          (static_cast<std::uint16_t>(static_cast<std::uint8_t>(b[pos + 1])) << 8);
        pos += 2;
        return v;
    }
    std::uint32_t u32() {
        if (pos + 4 > b.size()) { ok = false; return 0; }
        std::uint32_t v = 0;
        for (int i = 0; i < 4; ++i) {
            v |= static_cast<std::uint32_t>(static_cast<std::uint8_t>(b[pos + i])) << (8 * i);
        }
        pos += 4;
        return v;
    }
    std::string str(std::size_t n) {
        if (pos + n > b.size()) { ok = false; return {}; }
        std::string s(b.substr(pos, n));
        pos += n;
        return s;
    }
};

}  // namespace

std::array<std::uint8_t, 32> polbFingerprint(std::string_view publicApi) {
    Sha256 sha;
    sha.update(reinterpret_cast<const std::uint8_t*>(publicApi.data()), publicApi.size());
    return sha.final();
}

std::string writePolb(const PolbBundle& bundle) {
    std::string out;
    out.append(kMagic, 4);
    putU16(out, kFormatVersion);
    putU16(out, bundle.flags);
    putU16(out, bundle.abiRevision);
    out.append(reinterpret_cast<const char*>(bundle.fingerprint.data()), bundle.fingerprint.size());
    putStr16(out, bundle.name);
    putStr16(out, bundle.version);
    putStr16(out, bundle.producer);
    putStr32(out, bundle.polh);
    putStr32(out, bundle.code);
    putU16(out, static_cast<std::uint16_t>(bundle.deps.size()));
    for (const PolbDep& d : bundle.deps) {
        putStr16(out, d.name);
        putStr16(out, d.versionConstraint);
        out.append(reinterpret_cast<const char*>(d.fingerprint.data()), d.fingerprint.size());
    }
    putU16(out, static_cast<std::uint16_t>(bundle.capabilities.size()));
    for (const std::string& c : bundle.capabilities) {
        putStr16(out, c);
    }
    putU16(out, static_cast<std::uint16_t>(bundle.vtableSlots.size()));
    for (const std::string& s : bundle.vtableSlots) {
        putStr16(out, s);
    }
    return out;
}

bool readPolb(std::string_view bytes, PolbBundle& out) {
    if (bytes.size() < 4 || std::string_view(bytes.data(), 4) != std::string_view(kMagic, 4)) {
        return false;
    }
    Reader r{bytes, 4, true};
    if (r.u16() != kFormatVersion) {
        return false;  // unknown format version
    }
    out.flags = r.u16();
    out.abiRevision = r.u16();
    std::string fp = r.str(32);
    if (!r.ok) {
        return false;
    }
    std::copy(fp.begin(), fp.end(), reinterpret_cast<char*>(out.fingerprint.data()));
    out.name = r.str(r.u16());
    out.version = r.str(r.u16());
    out.producer = r.str(r.u16());
    out.polh = r.str(r.u32());
    out.code = r.str(r.u32());
    const std::uint16_t depCount = r.u16();
    for (std::uint16_t i = 0; i < depCount && r.ok; ++i) {
        PolbDep d;
        d.name = r.str(r.u16());
        d.versionConstraint = r.str(r.u16());
        std::string dfp = r.str(32);
        if (r.ok) {
            std::copy(dfp.begin(), dfp.end(), reinterpret_cast<char*>(d.fingerprint.data()));
        }
        out.deps.push_back(std::move(d));
    }
    const std::uint16_t capCount = r.u16();
    for (std::uint16_t i = 0; i < capCount && r.ok; ++i) {
        out.capabilities.push_back(r.str(r.u16()));
    }
    const std::uint16_t vtCount = r.u16();
    for (std::uint16_t i = 0; i < vtCount && r.ok; ++i) {
        out.vtableSlots.push_back(r.str(r.u16()));
    }
    return r.ok;
}

}  // namespace polaron
