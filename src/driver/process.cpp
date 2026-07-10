#include "driver/process.h"
#ifdef _WIN32
#include <process.h>
#include <windows.h>
#else
#include <sys/wait.h>
#include <unistd.h>
#endif

namespace ldp3::driver {

#ifdef _WIN32
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
    // Build a single quoted command line and hand it to CreateProcessA. This is NOT the same as
    // _spawnvp: the CRT's _spawn family joins argv with spaces WITHOUT quoting, so any argument with an
    // embedded space (a full exe path or a `-libpath:` under `C:\Program Files\LDP3`, the default install
    // location) is split into two by the child's command-line parser and the build fails. quoteArg wraps
    // every whitespace-bearing argument so paths with spaces survive. CreateProcessA with a NULL
    // application name still searches PATH and appends `.exe` for a bare token (so "git" resolves).
    std::string cmd = quoteArg(exe);
    for (const auto& a : args) cmd += " " + quoteArg(a);
    STARTUPINFOA si{};
    si.cb = sizeof(si);
    PROCESS_INFORMATION pi{};
    std::vector<char> buf(cmd.begin(), cmd.end());
    buf.push_back('\0');
    if (!CreateProcessA(nullptr, buf.data(), nullptr, nullptr, TRUE, 0, nullptr, nullptr, &si, &pi)) {
        return -1;
    }
    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD code = 0;
    GetExitCodeProcess(pi.hProcess, &code);
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
    return static_cast<int>(code);
}

int runProcessCapture(const std::string& exe, const std::vector<std::string>& args, std::string& output,
                      const std::string& cwd, bool mergeStderr) {
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
    si.hStdError = mergeStderr ? wr : GetStdHandle(STD_ERROR_HANDLE);
    si.hStdInput = GetStdHandle(STD_INPUT_HANDLE);
    PROCESS_INFORMATION pi{};
    std::vector<char> buf(cmd.begin(), cmd.end());
    buf.push_back('\0');
    const char* workDir = cwd.empty() ? nullptr : cwd.c_str();
    if (!CreateProcessA(nullptr, buf.data(), nullptr, nullptr, TRUE, 0, nullptr, workDir, &si, &pi)) {
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

#else  // POSIX

namespace {
// Build a NULL-terminated argv from (exe, args...). The vector's strings must outlive the argv use.
std::vector<char*> buildArgv(const std::string& exe, const std::vector<std::string>& args) {
    std::vector<char*> argv;
    argv.push_back(const_cast<char*>(exe.c_str()));
    for (const auto& a : args) argv.push_back(const_cast<char*>(a.c_str()));
    argv.push_back(nullptr);
    return argv;
}
}  // namespace

int runProcess(const std::string& exe, const std::vector<std::string>& args) {
    std::vector<char*> argv = buildArgv(exe, args);
    const pid_t pid = ::fork();
    if (pid < 0) return -1;
    if (pid == 0) {
        // execvp searches PATH when `exe` has no slash (so a bare "git" resolves) and uses a full path
        // as-is. No shell is involved, so paths with spaces are safe.
        ::execvp(exe.c_str(), argv.data());
        ::_exit(127);  // exec failed: the file was not found or is not executable
    }
    int status = 0;
    if (::waitpid(pid, &status, 0) < 0) return -1;
    return WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}

int runProcessCapture(const std::string& exe, const std::vector<std::string>& args, std::string& output,
                      const std::string& cwd, bool mergeStderr) {
    int fds[2];
    if (::pipe(fds) != 0) return -1;
    const pid_t pid = ::fork();
    if (pid < 0) {
        ::close(fds[0]);
        ::close(fds[1]);
        return -1;
    }
    if (pid == 0) {
        ::close(fds[0]);  // the child does not read from the pipe
        ::dup2(fds[1], STDOUT_FILENO);
        // Without mergeStderr the child's stderr keeps the parent's (goes to the console), matching the
        // Windows path.
        if (mergeStderr) ::dup2(fds[1], STDERR_FILENO);
        ::close(fds[1]);
        if (!cwd.empty() && ::chdir(cwd.c_str()) != 0) ::_exit(127);
        std::vector<char*> argv = buildArgv(exe, args);
        ::execvp(exe.c_str(), argv.data());
        ::_exit(127);
    }
    ::close(fds[1]);  // the parent does not write to the pipe
    char chunk[4096];
    ssize_t n = 0;
    while ((n = ::read(fds[0], chunk, sizeof(chunk))) > 0) output.append(chunk, static_cast<size_t>(n));
    ::close(fds[0]);
    int status = 0;
    if (::waitpid(pid, &status, 0) < 0) return -1;
    return WIFEXITED(status) ? WEXITSTATUS(status) : -1;
}

#endif

}  // namespace ldp3::driver
