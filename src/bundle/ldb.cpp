#include "bundle/ldb.h"

#include <llvm/ADT/ArrayRef.h>
#include <llvm/Support/SHA256.h>

namespace ldp3 {
namespace {

constexpr char kMagic[4] = {'L', 'D', 'B', '\x01'};
constexpr std::uint16_t kFormatVersion = 1;

void putU16(std::string& out, std::uint16_t v) {
    out.push_back(static_cast<char>(v & 0xFF));
    out.push_back(static_cast<char>((v >> 8) & 0xFF));
}
void putU32(std::string& out, std::uint32_t v) {
    for (int i = 0; i < 4; ++i) out.push_back(static_cast<char>((v >> (8 * i)) & 0xFF));
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
        for (int i = 0; i < 4; ++i) v |= static_cast<std::uint32_t>(static_cast<std::uint8_t>(b[pos + i])) << (8 * i);
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

std::array<std::uint8_t, 32> ldbFingerprint(std::string_view publicApi) {
    llvm::SHA256 sha;
    sha.update(llvm::ArrayRef<std::uint8_t>(
        reinterpret_cast<const std::uint8_t*>(publicApi.data()), publicApi.size()));
    return sha.final();
}

std::string writeLdb(const LdbBundle& bundle) {
    std::string out;
    out.append(kMagic, 4);
    putU16(out, kFormatVersion);
    putU16(out, bundle.flags);
    out.append(reinterpret_cast<const char*>(bundle.fingerprint.data()), bundle.fingerprint.size());
    putStr16(out, bundle.name);
    putStr16(out, bundle.version);
    putStr32(out, bundle.ldh);
    putStr32(out, bundle.code);
    putU16(out, static_cast<std::uint16_t>(bundle.deps.size()));
    for (const LdbDep& d : bundle.deps) {
        putStr16(out, d.name);
        putStr16(out, d.versionConstraint);
        out.append(reinterpret_cast<const char*>(d.fingerprint.data()), d.fingerprint.size());
    }
    putU16(out, static_cast<std::uint16_t>(bundle.capabilities.size()));
    for (const std::string& c : bundle.capabilities) putStr16(out, c);
    return out;
}

bool readLdb(std::string_view bytes, LdbBundle& out) {
    if (bytes.size() < 4 || std::string_view(bytes.data(), 4) != std::string_view(kMagic, 4))
        return false;
    Reader r{bytes, 4, true};
    if (r.u16() != kFormatVersion) return false;  // unknown format version
    out.flags = r.u16();
    std::string fp = r.str(32);
    if (!r.ok) return false;
    std::copy(fp.begin(), fp.end(), reinterpret_cast<char*>(out.fingerprint.data()));
    out.name = r.str(r.u16());
    out.version = r.str(r.u16());
    out.ldh = r.str(r.u32());
    out.code = r.str(r.u32());
    const std::uint16_t depCount = r.u16();
    for (std::uint16_t i = 0; i < depCount && r.ok; ++i) {
        LdbDep d;
        d.name = r.str(r.u16());
        d.versionConstraint = r.str(r.u16());
        std::string dfp = r.str(32);
        if (r.ok) std::copy(dfp.begin(), dfp.end(), reinterpret_cast<char*>(d.fingerprint.data()));
        out.deps.push_back(std::move(d));
    }
    const std::uint16_t capCount = r.u16();
    for (std::uint16_t i = 0; i < capCount && r.ok; ++i) out.capabilities.push_back(r.str(r.u16()));
    return r.ok;
}

}  // namespace ldp3
