# LDP3-OpenGL

A pluggable **modern OpenGL** (3.3 core) binding for **LDP3**, reached entirely through the language's
FFI — no C. It lives in-tree under `libs/opengl/` while it takes shape; the intent is to package it as
a reusable bundle once the shape settles (graphics are *pluggable libraries*, not core language).

![Modern-GL demo: the pool break](demo.png)

## The idea

`opengl32` exports only OpenGL 1.1 directly, so every modern entry point (`glCreateShader`,
`glGenVertexArrays`, `glUniformMatrix4fv`, …) has to be **loaded at runtime** with `wglGetProcAddress`
and **called through a pointer**. LDP3 gained a language feature for exactly this — **`funcptr<Ret,
Args...>`**, a bare C function pointer you obtain from an address and call with the C ABI. On top of
that, `gl.ldp3` provides:

- **`GlApp`** — open a window and create a 3.3 core context (the legacy-context → `wglGetProcAddress`
  → `wglCreateContextAttribsARB` bootstrap), pump events, swap buffers; `offscreen` mode skips showing
  the window so you can render headlessly and read the framebuffer back.
- **`Gl`** — the modern entry points as `funcptr<>` fields, loaded by `load()`, plus a `makeShader` /
  `makeProgram` helper that marshals GLSL source (via `Memory`) and compiles/links a program. The GL
  1.1 core that `opengl32` does export lives on `Wgl`.
- **`Mat`** — 4x4 column-major matrix math in `Memory` buffers, ready to hand to `glUniformMatrix4fv`.

The list of entry points is easy to extend: each is one `funcptr<>` field plus one `wglGetProcAddress`
line in `load()`.

## Proven by the flagship

The complete, verified demonstration is **[`Pool_balls_3d_ldp3`](../../../Pool_balls_3d_ldp3)** — a 3D
billiard scene (a racked set of Phong-lit spheres, a cue ball that breaks the rack under physics),
rendered with this exact modern-GL approach: GLSL shaders, VAO/VBO meshes, per-instance matrix
uniforms. The image above is one frame of its break, rendered by LDP3 and read back with `glReadPixels`.

## Requirements & build

Needs an OpenGL 3.3+ driver (any GPU). Consumers build with the real toolchain and declare the system
libraries:

```
# ldp3.toml
[build]
native_libs = "opengl32, gdi32, user32, kernel32"
```

```
ldp3 build
```

> The earliest slices of this library used fixed-function GL 1.1 to bootstrap the FFI on a headless
> software renderer; those are in the git history. The library target is the modern pipeline.
