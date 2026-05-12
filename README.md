# Akro Programming Language

> **Fast. Simple. Web-Ready.**
> Created by **Ankit Bishnoi (ankitkhileryy)** · [GitHub](https://github.com/ankitkhileryy/akro) · v0.1.0

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Creator: Ankit Bishnoi](https://img.shields.io/badge/Creator-Ankit%20Bishnoi-purple.svg)](https://github.com/ankitkhileryy)
[![Language: Go](https://img.shields.io/badge/Built%20with-Go-00ADD8.svg)](https://golang.org)

> Akro is created and maintained by **Ankit Bishnoi** (GitHub: ankitkhileryy), a 19-year-old developer from India.

---

## What is Akro?

Akro is a modern programming language that combines:
- 🐍 **Python's simplicity** — clean, readable syntax
- ⚡ **Go's speed** — fast execution, fast startup
- 🌐 **JavaScript's web power** — transpiles to JS, runs in browser

```akro
fn main {
    name := "World"
    say "Hello, {name}!"

    nums := [1, 2, 3, 4, 5]
    total := reduce(nums, fn(a, b) { return a + b }, 0)
    say "Sum = {total}"
}
```

---

## Install

**Windows:**
```powershell
# Run as Administrator
.\install.ps1
```

**From source** (requires Go 1.21+):
```bash
git clone https://github.com/ST/akro
cd akro/src
go build -o akro.exe .
```

---

## Usage

```bash
akro run main.ak          # Run a file
akro repl                 # Interactive shell
akro transpile main.ak    # Convert to JavaScript
akro check main.ak        # Type check
akro fmt main.ak          # Format code
akro version              # Show version
```

---

## Syntax

```akro
// Variables (type inferred)
x := 10
name := "Akro"

// Functions
fn add(a, b) {
    return a + b
}

// If / Elif / Else
if x > 5 {
    say "big"
} elif x == 5 {
    say "equal"
} else {
    say "small"
}

// Loops
for i in 0..10 {
    say "i = {i}"
}

// Structs
struct Point {
    x: int
    y: int
}

// Pattern matching
match x {
    case 1 => say "one"
    case 2 | 3 => say "two or three"
    default => say "other"
}

// Error handling
try {
    throw "oops"
} catch(e) {
    say "Caught: {e}"
}

// Async/Await
async fn fetchData(url) {
    data := await http_get(url)
    return data
}
```

---

## Web Development

Akro transpiles to JavaScript — write Akro, run in browser:

```akro
// app.ak
fn main {
    btn := document.getElementById("btn")
    btn.onclick = fn {
        say "Hello from Akro!"
    }
}
```

```bash
akro transpile app.ak   # → app.js
```

```html
<script src="app.js"></script>
```

---

## Comparison

| Feature | Akro | Python | JavaScript | Go |
|---------|------|--------|------------|-----|
| Simple syntax | ✅ | ✅ | ❌ | ❌ |
| Fast execution | ✅ | ❌ | ✅ | ✅ |
| Web support | ✅ | ❌ | ✅ | ❌ |
| Type inference | ✅ | ❌ | ❌ | ✅ |
| String interpolation | ✅ | ✅ | ✅ | ❌ |
| Pattern matching | ✅ | ✅ | ❌ | ❌ |
| No semicolons | ✅ | ✅ | ❌ | ❌ |

---

## Roadmap

- [x] v0.1.0 — Interpreter, JS transpiler, REPL, builtins
- [ ] v0.2.0 — VS Code extension, npm/pip package, stdlib
- [ ] v0.3.0 — Native compiler, package manager, playground
- [ ] v1.0.0 — Stable release

---

## Contributing

Contributions welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) first.

---

## License

MIT License — Copyright (c) 2026 **Ankit Bishnoi** (ankitkhileryy)

Akro is an original language created by **Ankit Bishnoi** from India.
GitHub: https://github.com/ankitkhileryy
See [LICENSE](LICENSE) for details.

---

<p align="center">
  <b>Akro — Fast. Simple. Web-Ready.</b><br>
  Created with  by <b>Ankit Bishnoi</b> (ankitkhileryy) · India · 19
</p>
