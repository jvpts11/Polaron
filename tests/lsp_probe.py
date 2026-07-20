#!/usr/bin/env python3
"""Drive ldp3-lsp over the real LSP protocol and check what it answers.

The unit tests cover the JSON layer; this covers the server as a PROCESS -- headers, request
dispatch, and the shape of the replies -- which is what an editor actually talks to. Run as:

    python lsp_probe.py <path-to-ldp3-lsp>

Exits non-zero on the first mismatch, printing what was expected and what came back.
"""

import json
import subprocess
import sys

SRC = """program Demo;
public bundle main {
    public namespace app {
        public class Calc {
            private mutable int total;
            public method addTwo(int a, int b) returns int {
                return a + b;
            }
            public static method main(string[] args) returns void {
                Calc c = new Calc();
                int s = c.addTwo(10, 32);
                return;
            }
        }
    }
}
"""

URI = "file:///demo.ldp3"
failures = []


def check(label, actual, expected):
    if actual != expected:
        failures.append(f"{label}: expected {expected!r}, got {actual!r}")
    else:
        print(f"  ok  {label}")


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: lsp_probe.py <path-to-ldp3-lsp>")
        return 2
    proc = subprocess.Popen([sys.argv[1]], stdin=subprocess.PIPE, stdout=subprocess.PIPE)

    def send(obj):
        body = json.dumps(obj).encode()
        proc.stdin.write(b"Content-Length: %d\r\n\r\n" % len(body) + body)
        proc.stdin.flush()

    def read():
        length = 0
        while True:
            line = proc.stdout.readline()
            if not line or line in (b"\r\n", b"\n"):
                break
            if line.lower().startswith(b"content-length:"):
                length = int(line.split(b":")[1])
        return json.loads(proc.stdout.read(length)) if length else None

    send({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {}})
    caps = read()["result"]["capabilities"]
    check("advertises definitionProvider", caps.get("definitionProvider"), True)
    check("advertises hoverProvider", caps.get("hoverProvider"), True)

    send({"jsonrpc": "2.0", "method": "textDocument/didOpen",
          "params": {"textDocument": {"uri": URI, "text": SRC}}})
    check("clean file has no diagnostics", read()["params"]["diagnostics"], [])

    # Line 10 is `int s = c.addTwo(10, 32);` -- the cursor sits inside the call.
    send({"jsonrpc": "2.0", "id": 2, "method": "textDocument/definition",
          "params": {"textDocument": {"uri": URI}, "position": {"line": 10, "character": 28}}})
    loc = read()["result"]
    # addTwo is declared on line 5 at column 26. The range must cover the NAME, not the `method`
    # keyword the declaration's location points at.
    check("definition line", loc["range"]["start"]["line"], 5)
    check("definition start col", loc["range"]["start"]["character"], 26)
    check("definition end col", loc["range"]["end"]["character"], 32)

    send({"jsonrpc": "2.0", "id": 3, "method": "textDocument/hover",
          "params": {"textDocument": {"uri": URI}, "position": {"line": 10, "character": 28}}})
    hover = read()["result"]["contents"]["value"]
    check("hover shows the signature",
          "public method Calc.addTwo(int a, int b) returns int" in hover, True)

    # A class name resolves too, to its own declaration line.
    send({"jsonrpc": "2.0", "id": 4, "method": "textDocument/definition",
          "params": {"textDocument": {"uri": URI}, "position": {"line": 9, "character": 17}}})
    check("class definition line", read()["result"]["range"]["start"]["line"], 3)

    # A name this file does not declare must come back null, so the editor falls back to its own
    # search instead of jumping somewhere wrong.
    send({"jsonrpc": "2.0", "id": 5, "method": "textDocument/definition",
          "params": {"textDocument": {"uri": URI}, "position": {"line": 0, "character": 9}}})
    check("undeclared name returns null", read()["result"], None)

    send({"jsonrpc": "2.0", "id": 9, "method": "shutdown", "params": {}})
    read()
    send({"jsonrpc": "2.0", "method": "exit"})
    proc.wait(timeout=10)

    if failures:
        print("\nFAILED:")
        for f in failures:
            print("  " + f)
        return 1
    print("\nlsp probe: all checks passed")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
