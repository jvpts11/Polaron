#include "driver/process.h"
#include <process.h>
#include <windows.h>

namespace ldp3::driver {
namespace {

// Quote an argument for a Windows command line if it contains whitespace or quotes.
std::string quoteArg(const std::string& a) {
    if (a.find_first_of(" \t\"") == std::string::npos) return a;
    std::string q = "\"";
    for (char c : a) {
        if (c == '"') q += '\\';
        q += c;
    }
    q += "\"";
    return q;
}

}  // namespace

int runProcess(const std::string& exe, const std::vector<std::string>& args) {
    std::vector<const char*> argv;
    argv.push_back(exe.c_str());
    for (const auto& a : args) argv.push_back(a.c_str());
    argv.push_back(nullptr);
    // _spawnvp searches PATH when `exe` has no path separator (so a bare "git" resolves), and uses a full
    // path as-is (clang/ldp3c). No shell is involved, so paths with spaces are safe. _P_WAIT returns the
    // child's exit code.
    const intptr_t rc = _spawnvp(_P_WAIT, exe.c_str(), argv.data());
    return static_cast<int>(rc);
}

int runProcessCapture(const std::string& exe, const std::vector<std::string>& args, std::string& output) {
    std::string cmd = quoteArg(exe);
    for (const auto& a : args) cmd += " " + quoteArg(a);

    SECURITY_ATTRIBUTES sa{};
    sa.nLength = sizeof(sa);
    sa.bInheritHandle = TRUE;
    HANDLE rd = nullptr, wr = nullptr;
    if (!CreatePipe(&rd, &wr, &sa, 0)) return -1;
    SetHandleInformation(rd, HANDLE_FLAG_INHERIT, 0);

    STARTUPINFOA si{};
    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESTDHANDLES;
    si.hStdOutput = wr;
    si.hStdError = GetStdHandle(STD_ERROR_HANDLE);
    si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    PROCESS_INFORMATION pi{};
    std::vector<char> buf(cmd.begin(), cmd.end());
    buf.push_back('\0');
    if (!CreateProcessA(nullptr, buf.data(), nullptr, nullptr, TRUE, 0, nullptr, nullptr, &si, &pi)) {
        CloseHandle(rd);
        CloseHandle(wr);
        return -1;
    }
    CloseHandle(wr);  // the parent does not write to the pipe
    char chunk[4096];
    DWORD n = 0;
    while (ReadFile(rd, chunk, sizeof(chunk), &n, nullptr) && n > 0) output.append(chunk, n);
    CloseHandle(rd);
    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD code = 0;
    GetExitCodeProcess(pi.hProcess, &code);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return static_cast<int>(code);
}

}  // namespace ldp3::driver
