use rustix::system::uname;
use std::fs;
use std::io::{BufRead, BufReader};

fn main() {
    #[cfg(any(target_arch = "x86", target_arch = "x86_64"))]
    let arch = "x86";
    #[cfg(any(target_arch = "arm", target_arch = "aarch64"))]
    let arch = "ARM";
    #[cfg(any(target_arch = "mips", target_arch = "mipsle"))]
    let arch = "MIPS";
    #[cfg(any(target_arch = "riscv64", target_arch = "riscv32"))]
    let arch = "RISC-V";
    println!("Let's have a look at your shiny {} system! :)\n", arch);

    let mut f = "/proc/cpuinfo";
    let cpuinfo = fs::read_to_string(f).expect("cpuinfo err");
    println!("cpuinfo:\n{}", cpuinfo);

    f = "/proc/meminfo";
    match fs::File::open(f) {
        Ok(file) => {
            println!("meminfo:");
            BufReader::new(file)
                .lines()
                .take(3)
                .filter_map(Some)
                .for_each(|l| println!("{}", l.unwrap()));
            println!();
        }
        Err(e) => println!("{}\n", e),
    }

    f = "/proc/cmdline";
    let cmdline = fs::read_to_string(f).expect("cmdline err");
    println!("cmdline:\n{}", cmdline);

    let kernel = uname();
    println!(
        "kernel:\n{:}/{:} {:}\n  version: {:} ({:})",
        kernel.sysname().to_str().unwrap(),
        kernel.nodename().to_str().unwrap(),
        kernel.domainname().to_str().unwrap(),
        kernel.release().to_str().unwrap(),
        kernel.version().to_str().unwrap(),
    );
}
