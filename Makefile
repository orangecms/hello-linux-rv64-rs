all: aarch64 arm riscv x86

x86:
	cargo build --release --target x86_64-unknown-linux-gnu

riscv:
	cargo build --release --target riscv64gc-unknown-linux-gnu

aarch64:
	cargo build --release --target aarch64-unknown-linux-gnu

arm:
	cargo build --release --target arm-unknown-linux-gnueabi

mipsle:
	cargo build --release --target mipsel-unknown-linux-musl
