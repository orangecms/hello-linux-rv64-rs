# Hello Linux RISC-V 64

This tiny tool lets you print some information from `/proc` and `uname` from
Linux on RISC-V 64. 

## Build

You will need [Rust](https://www.rust-lang.org/) and the linker from
`riscv64-linux-gnu-gcc`.

```sh
cargo build --release
```

## Run via [`cpu`](https://github.com/u-root/cpu)

```sh
cpu -key ~/.ssh/cpu_rsa -timeout9p 2000ms target-host \
  ./target/riscv64gc-unknown-linux-gnu/release/hello-rust
```
