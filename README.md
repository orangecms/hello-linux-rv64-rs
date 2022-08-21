# Hello Linux RISC-V 64

This tiny tool lets you print some information from `/proc` and `uname` from
Linux on RISC-V 64. 

## Build

### Rust Version

You will need [Rust](https://www.rust-lang.org/) and the linker from
`riscv64-linux-gnu-gcc`.

```sh
cargo build --release
```

or `zig` linker:

```sh
cargo install cargo-zigbuild

cargo zigbuild --release
```

### Zig version
You will need [Zig](https://www.ziglang.org/)

```sh
# zig version v0.10 or higher (default self-hosting compiler [stage2 or stage3]) 
zig build -Drelease-safe|-Drelease-fast|-Drelease-small -target arch-os-libc

# execute
zig build run

# all targets
zig targets | jq .libc
```

## Run via [`cpu`](https://github.com/u-root/cpu)

```sh
cpu -key ~/.ssh/cpu_rsa -timeout9p 2000ms target-host \
  ./target/riscv64gc-unknown-linux-gnu/release/hello-rust
  or
  ./zig-out/bin/hello-zig
```
