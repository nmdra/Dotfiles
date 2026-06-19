---
name: pkggodev-api
description: >
  Use this skill whenever an agent needs to query Go package/module metadata from
  pkg.go.dev. Triggers include: looking up Go package info, finding module versions,
  searching for Go packages, listing package symbols (types/functions/methods),
  checking what packages import a given package, checking for vulnerabilities in Go
  modules, or any task requiring structured data about the Go ecosystem. Also use when
  the user asks to "find a Go package", "check the latest version of a Go module",
  "look up Go API docs programmatically", or wants to build a tool that integrates
  with pkg.go.dev. Always use this skill rather than web-scraping or guessing at
  Go package metadata.
---

# pkg.go.dev API Skill

The official pkg.go.dev JSON API provides structured metadata about published Go
modules and packages. All endpoints are GET requests under `https://pkg.go.dev`.
The API is currently under the `/v1beta` path prefix.

## Key Design Principles

- **Stateless GET-only**: no authentication, no request body, all params are query strings.
- **Precision over convenience**: ambiguous package paths return an error with candidates — always disambiguate with `?module=`.
- **Rate limit**: 40 QPS per IP block. Response headers `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`.
- **Pagination**: responses with lists have `nextPageToken`; pass `?token=<value>` to continue.

---

## Endpoints Quick Reference

| Endpoint | What it returns |
|---|---|
| `/v1beta/package/{path}` | Metadata for a single package |
| `/v1beta/module/{path}` | Metadata for a module |
| `/v1beta/versions/{path}` | All versions of a module |
| `/v1beta/packages/{path}` | All packages inside a module |
| `/v1beta/search?q={query}` | Search results for packages |
| `/v1beta/symbols/{path}` | Types, functions, methods in a package |
| `/v1beta/imported-by/{path}` | Packages that import this package |
| `/v1beta/vulns/{path}` | Known vulnerabilities for a module/package |

---

## Common Parameters

| Param | Applies to | Description |
|---|---|---|
| `module` | package, symbols, imported-by | Disambiguate when path matches multiple modules |
| `version` | package, module, versions, symbols | Semver tag (e.g. `v1.2.3`), `latest`, `master`, or `main` |
| `goos` / `goarch` | package, symbols | Build context (default: `linux/amd64`) |
| `doc` | package | Return docs as `text`, `html`, `md`, or `markdown` |
| `imports` | package | Include imported packages (`true`/`false`) |
| `licenses` | package, module | Include license info (`true`/`false`) |
| `limit` | paginated routes | Max items to return |
| `token` | paginated routes | Pagination cursor from `nextPageToken` |
| `filter` | most list routes | Go expression filter (see Filtering section) |

---

## Endpoint Details

### `/v1beta/package/{path}` — Package info

```bash
curl "https://pkg.go.dev/v1beta/package/golang.org/x/time/rate"
```

**Key response fields:**
```json
{
  "modulePath": "golang.org/x/time",
  "version": "v0.15.0",
  "isLatest": true,
  "path": "golang.org/x/time/rate",
  "name": "rate",
  "synopsis": "Package rate provides a rate limiter.",
  "isRedistributable": true,
  "goos": "all",
  "goarch": "all"
}
```

**Disambiguation:** If the path is ambiguous, the API returns a 400 with a `candidates` field. Retry with `?module=<modulePath>`.

---

### `/v1beta/module/{path}` — Module info

```bash
curl "https://pkg.go.dev/v1beta/module/golang.org/x/time"
```

**Key response fields:**
```json
{
  "path": "golang.org/x/time",
  "version": "v0.15.0",
  "commitTime": "2026-02-11T19:14:29Z",
  "isLatest": true,
  "hasGoMod": true,
  "repoUrl": "https://cs.opensource.google/go/x/time"
}
```

---

### `/v1beta/versions/{path}` — Module versions

```bash
curl "https://pkg.go.dev/v1beta/versions/golang.org/x/time?limit=5"
```

Returns tagged versions in descending order. Falls back to 10 most recent pseudo-versions if no tags exist.

**Key response fields per item:**
```json
{
  "modulePath": "golang.org/x/time",
  "version": "v0.15.0",
  "commitTime": "2026-02-11T19:14:29Z",
  "latestVersion": "v0.15.0",
  "deprecated": false,
  "retracted": false
}
```

---

### `/v1beta/packages/{path}` — Packages in a module

```bash
curl "https://pkg.go.dev/v1beta/packages/golang.org/x/time"
```

Note: `{path}` must be a **module** path, not a package path. Will error if given a package path.

---

### `/v1beta/search?q={query}` — Search

```bash
curl "https://pkg.go.dev/v1beta/search?q=uuid&limit=5"
```

Optional `symbol` param to filter by exported symbol name.

**Key response fields per item:**
```json
{
  "packagePath": "github.com/google/uuid",
  "modulePath": "github.com/google/uuid",
  "version": "v1.6.0",
  "synopsis": "Package uuid generates and inspects UUIDs."
}
```

---

### `/v1beta/symbols/{path}` — Package symbols

```bash
curl "https://pkg.go.dev/v1beta/symbols/golang.org/x/time/rate"
```

**Key response fields per symbol:**
```json
{
  "name": "NewLimiter",
  "kind": "Function",
  "synopsis": "func NewLimiter(r Limit, b int) *Limiter",
  "parent": "Limiter"
}
```

Symbol kinds: `Type`, `Function`, `Method`, `Field`, `Constant`, `Variable`.

---

### `/v1beta/imported-by/{path}` — Reverse imports

```bash
curl "https://pkg.go.dev/v1beta/imported-by/golang.org/x/time/rate?limit=10"
```

Returns import paths of packages that depend on this package (excluding same-module packages).

---

### `/v1beta/vulns/{path}` — Vulnerabilities

```bash
curl "https://pkg.go.dev/v1beta/vulns/golang.org/x/image"
```

Data sourced from the Go vulnerability database at https://vuln.go.dev.

---

## Filtering

Filters are Go expressions that evaluate to `bool`. Passed as `?filter=<url-encoded-expression>`.

**Supported operations:**
- Equality: `==`, `!=`
- Comparisons: `<`, `<=`, `>`, `>=`
- Arithmetic: `+`, `-`, `*`, `/`, `%`
- Functions: `contains(s, sub)`, `hasPrefix(s, pre)`, `hasSuffix(s, suf)`, `matches(s, re)`
- Values: `true`, `false`, `nil`

**Variable names** correspond to JSON field names of the list items.

**Example** — filter versions to only patch releases of v0.5.x:
```
filter=hasPrefix(version, "v0.5.")
```
URL-encoded: `filter=hasPrefix%28version%2C+%22v0.5.%22%29`

**Example** — filter symbols to only Functions:
```
filter=kind == "Function"
```

Always percent-encode filter values before including in URLs.

---

## Handling Pagination

```python
import requests, urllib.parse

def get_all_versions(module_path):
    url = f"https://pkg.go.dev/v1beta/versions/{module_path}"
    items = []
    token = None
    while True:
        params = {"limit": 50}
        if token:
            params["token"] = token
        r = requests.get(url, params=params)
        data = r.json()
        items.extend(data.get("items", []))
        token = data.get("nextPageToken")
        if not token:
            break
    return items
```

---

## Disambiguation Pattern

When a package path is ambiguous, the API returns HTTP 400 with a `candidates` field:

```json
{
  "code": 400,
  "message": "ambiguous import path ...",
  "candidates": ["example.com/a", "example.com/a/b"]
}
```

**Resolution:** Pick the appropriate candidate and retry with `?module=<candidate>`.

```bash
# Ambiguous — may error
curl "https://pkg.go.dev/v1beta/package/example.com/a/b/c"

# Explicit module — always unambiguous
curl "https://pkg.go.dev/v1beta/package/example.com/a/b/c?module=example.com/a/b"
```

---

## Error Response Shape

All errors are JSON:

```json
{
  "code": 400,
  "message": "human-readable description",
  "candidates": ["..."],   // present on ambiguity errors
  "fixes": ["..."]         // present when the API can suggest corrections
}
```

Common HTTP codes:
- `400` — bad request (malformed path, ambiguous package, wrong path type)
- `404` — module/package not found
- `429` — rate limit exceeded

---

## Practical Recipes

### Find the latest version of a module
```bash
curl -s "https://pkg.go.dev/v1beta/module/github.com/google/go-cmp" | jq '.version'
```

### List all exported functions in a package
```bash
curl -s "https://pkg.go.dev/v1beta/symbols/golang.org/x/time/rate?filter=kind+%3D%3D+%22Function%22"
```

### Search and get top result's module
```bash
curl -s "https://pkg.go.dev/v1beta/search?q=yaml+parser&limit=1" | jq '.items[0].modulePath'
```

### Check if a version is retracted
```bash
curl -s "https://pkg.go.dev/v1beta/versions/github.com/some/module" | \
  jq '.items[] | select(.version == "v1.0.0") | .retracted'
```

---

## Reference

- Full OpenAPI spec: `https://pkg.go.dev/v1beta/api` (machine-readable)
- Reference CLI: `go install golang.org/x/pkgsite/cmd/internal/pkgsite-cli@latest`
- Vuln database: https://vuln.go.dev
- Official announcement: https://go.dev/blog/pkgsite-api
