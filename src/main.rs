#![feature(asm)]

use rustix::process::uname;
use std::fs;

fn main() {
    let mut f = "/proc/cpuinfo";
    let cpuinfo = fs::read_to_string(f).expect("cpuinfo err");
    println!("cpuinfo:\n{}", cpuinfo);
    f = "/proc/cmdline";
    let cmdline = fs::read_to_string(f).expect("cmdline err");
    println!("cmdline:\n{}", cmdline);

    let kernel = uname();
    println!("kernel:\n{:x?}", kernel);
}
