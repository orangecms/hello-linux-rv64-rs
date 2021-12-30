#![feature(asm)]

use rustix::process::uname;
use std::fs;
use std::io::{BufRead, BufReader};

fn main() {
    println!("Let's have a look at your shiny RISC-V system! :)\n");

    let mut f = "/proc/cpuinfo";
    let cpuinfo = fs::read_to_string(f).expect("cpuinfo err");
    println!("cpuinfo:\n{}", cpuinfo);

    f = "/proc/meminfo";
    match fs::File::open(f) {
        Ok(file) => {
            let mut lines = BufReader::new(file).lines();
            println!("meminfo:");
            for _ in 0..3 {
                if let Some(l) = lines.next() {
                    println!("{}", l.unwrap());
                }
            }
            println!();
        }
        Err(e) => println!("{}\n", e),
    }

    f = "/proc/cmdline";
    let cmdline = fs::read_to_string(f).expect("cmdline err");
    println!("cmdline:\n{}", cmdline);

    let kernel = uname();
    println!("kernel:\n{:x?}", kernel);
}
