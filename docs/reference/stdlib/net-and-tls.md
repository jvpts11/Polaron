# Standard Library — Networking and TLS

`import System.Net.Socket;` · `import System.Net.HttpClient;` · `import System.Net.Tls.TlsClient;`

Two layers, and the second is the unusual one. The first is what every language has: sockets, an HTTP
client, a URL parser, a small server-side router. The second is a **TLS 1.3 implementation written in
Polaron itself** — the handshake, the key schedule, the record layer, X.509 parsing and chain
validation — talking to real servers on the public internet, with no OpenSSL and no C.

That is here for the same reason the standard library is written in Polaron rather than bound to a C
one: a language that cannot express its own cryptography is a language with a hole in the middle of
it, and the hole is exactly where every program that matters has to go.

---

## 1. Sockets

```polaron
import System.Net.Socket;
import System.Net.ServerSocket;
import System.Net.UdpSocket;
```

| Member | What it does |
|---|---|
| `Socket.connect(String host, int port) returns Socket` | Opens a TCP connection. |
| `socket.isOpen() returns boolean` | Whether the handle is live. |
| `socket.send(String data) returns long` | Bytes written, or negative on failure. |
| `socket.receive(int max) returns String` | Up to `max` bytes; empty at end of stream. |
| `socket.close() returns void` | Closes it. Idempotent. |
| `ServerSocket.listen(int port)` / `.accept() returns Socket` | The listening half. |
| `UdpSocket` — `send(host, port, data)`, `receive(max) returns Datagram` | Datagrams, with the sender's address on the way back. |

A `Socket` is a handle and not a stream: it says how many bytes it moved and lets the caller decide
what a message is. Everything above it in this page is built from exactly these five calls.

---

## 2. `Url` — parsing, and the part everybody gets wrong

```polaron
Url u = Url.parse("https://example.org:8443/docs/a?q=1#top");
u.scheme();          // "https"
u.host();            // "example.org"
u.port();            // 8443, or the scheme's default when absent
u.path();            // "/docs/a"
u.query();           // "q=1"
u.fragment();        // "top"
u.isSecure();        // true
u.requestTarget();   // "/docs/a?q=1"  -- what goes on the request line
u.authority();       // "example.org:8443"
u.resolve("../b");   // a new Url, resolved against this one
```

`resolve` is the one worth knowing about: a relative reference against a base URL is the operation
every crawler, every redirect and every HTML link needs, and hand-rolling it with string
concatenation is how a program ends up fetching `https://example.org/docs/../b`.

---

## 3. HTTP

### The request

```polaron
import System.Net.HttpRequest;

HttpRequest* r = HttpRequest.post("https://api.example.org/v1/things") on heap;
r.setJson("{\"name\":\"one\"}");
r.setHeader("Authorization", "Bearer " + token);
```

| Builder | Note |
|---|---|
| `HttpRequest.get/post/put/patch/head(String url)` | The verb, and the URL parsed into a `Url`. |
| `HttpRequest.remove(String url)` | `DELETE`. Named `remove` because `delete` is a keyword. |
| `setBody` / `setJson` / `setForm` | The body, and the content type that goes with it. |
| `setBasicAuth(user, password)` | Base64 credentials, written once rather than at every call site. |
| `setHeader` / `header` | Anything else. |
| `toWire() returns String` | The exact bytes that will go out — for logging, and for tests that assert on the request rather than on a server. |

### Sending it

```polaron
import System.Net.HttpClient;

HttpResponse res = HttpClient.send(r);
if (res.status() == 200) {
    System.IO.Console.println(res.body());
}
```

| Member | What it does |
|---|---|
| `HttpClient.send(HttpRequest* r) returns HttpResponse` | One request. **`https` goes through the TLS stack below**, with the machine's trust store. |
| `HttpClient.sendFollowing(HttpRequest* r, int limit)` | The same, following up to `limit` redirects. |
| `HttpClient.fetch(String url) returns HttpResponse` | A GET, for the common case. |
| `HttpClient.get(String host, int port, String path)` | Plain HTTP, no URL parsing. |
| `res.status()` / `res.body()` / `res.header(name)` / `res.hasHeader(name)` / `res.raw()` | The response, and the unparsed bytes when something needs them. |

### Serving

`ServerRequest`, `ServerResponse` and `Router` are the other side: parse a request off a socket,
match it against a pattern, answer.

```polaron
Router* routes = new Router() on heap;
routes.get("/things/{id}", lambda[](ServerRequest* q) returns ServerResponse* {
    return new ServerResponse(ServerResponse.json("{\"id\":\"" + q.param("id") + "\"}")) on heap;
});
ServerResponse* answer = routes.dispatch(request);
```

| Member | What it does |
|---|---|
| `Router.add(verb, pattern, handler)` / `.get` / `.post` | A route. A pattern is path segments, with `{name}` capturing one: `/users/{id}/posts` matches `/users/42/posts` and gives `param("id")` = `"42"`. |
| `router.dispatch(ServerRequest*) returns ServerResponse*` | **The first match, in the order the routes were added** — which is the rule that lets a specific path be registered before a general one. A 404 when nothing matches. |
| `Route` | One entry: the verb, the pattern and the handler. Held by the router; public because a router of your own wants the same record. |
| `request.param(name)` | A captured segment. `query(name)` reads the query string instead. |
| `ServerResponse.ok/json/notFound/of(status, body)` | The usual answers. `toRaw()` is the wire form. |

---

## 4. TLS 1.3, written in Polaron

```polaron
import System.Net.Tls.TlsClient;
import System.Net.Tls.TlsSession;

TlsSession* s = TlsClient.open("example.org", 443);
s.send("GET / HTTP/1.1\r\nHost: example.org\r\nConnection: close\r\n\r\n");
String page = s.receive();
s.close();
delete s;
```

| Member | What it does |
|---|---|
| `TlsClient.open(host, port)` | Connects, handshakes and validates against the **system trust store**. |
| `TlsClient.connect(host, port, TrustStore*)` | The same with a trust store you chose. |
| `TlsClient.over(Socket, host, TrustStore*)` | Wraps a socket somebody else opened. |
| `TlsClient.systemTrust() returns TrustStore*` | The machine's roots, read once — walking every root the OS holds costs about half a second, so a client that paid it per request would be a client nobody uses twice. |
| `session.send(String)` / `.receive() returns String` / `.isOpen()` / `.close()` | The stream, encrypted. |

**What is implemented:** TLS 1.3 (RFC 8446) with X25519 and P-256/P-384 key exchange, AES-GCM record
protection, the HKDF key schedule, and full X.509: DER parsing, chain building, name checks, validity
windows, basic constraints, RSA (PKCS#1 v1.5 and PSS) and ECDSA signature verification.

### The pieces, for anybody who needs one on its own

| Type | What it is |
|---|---|
| `TrustStore` | A set of root certificates. `systemTrust()` fills it from the OS. |
| `Certificate` | One X.509 certificate: `fromPem`, `dnsNames`, `notBefore`/`notAfter`, `isValidAt`, `isCertificateAuthority`, `isIssuedBy`, `subjectCommonName`, the public key, the signature and its algorithm. |
| `CertificateValidator.check(chain, host, trusted, nowSeconds)` | Validates a chain **by throwing**, naming what failed — an expired leaf, a name that does not match, a missing issuer. A boolean answer would lose which of those it was. |
| `Der`, `Oid` | The encoding underneath: lengths, tags, well-formedness, and the object identifiers by name. |
| `Rsa` — `verifyPkcs1`, `verifyPss`, `verifySha256` | Signature verification. |
| `Sha` — `sha256()`, `sha384()`, `sha512()`, `forAlgorithm(alg)` | The digest a certificate asks for, chosen by its own algorithm id. |
| `RsaPublicKey` | A parsed RSA key: the modulus and exponent a `Certificate` hands back from `rsaPublicKey()`. |
| `Hkdf`, `KeySchedule`, `KeyShare`, `Gcm`, `Record`, `Wire`, `ClientHello`, `Alert` | The handshake and record layer, if you are implementing a protocol on top rather than using one. |
| `ByteWriter` | The wire builder underneath them: length-prefixed fields written in the order the protocol names them, so a handshake message is assembled rather than concatenated. |
| `X25519`, `Curve`, `EcPoint`, `Mont`, `U256` | The curve arithmetic. |
| `TlsException`, `CertificateException` | What a refusal throws. |

### Where it fits

`HttpClient` uses this automatically for `https`, so ordinary code never names it. Reach for
`TlsSession` directly when the protocol is not HTTP — a mail server, a message broker, a database
wire protocol.

> **The one decision still open:** whether TLS **1.2** joins it. Some server estates (and one SQL
> Server dialect) still require it. Until then a peer that refuses 1.3 is a peer this client cannot
> talk to, and it says so rather than falling back silently.
