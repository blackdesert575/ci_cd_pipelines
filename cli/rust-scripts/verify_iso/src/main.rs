use std::fs::File;
use std::io::{self, BufRead, Read};
use std::path::PathBuf;

use clap::{Arg, Command};
use sha2::{Digest, Sha256};

fn compute_sha256<P: Into<PathBuf>>(path: P) -> io::Result<String> {
    let mut file = File::open(path.into())?;
    let mut hasher = Sha256::new();
    let mut buffer = [0u8; 65536];

    loop {
        let count = file.read(&mut buffer)?;
        if count == 0 {
            break;
        }
        hasher.update(&buffer[..count]);
    }

    Ok(format!("{:x}", hasher.finalize()))
}

fn verify_with_hash(file: &PathBuf, expected: &str) -> io::Result<bool> {
    let actual = compute_sha256(file)?;
    println!("✅ 計算值: {}", actual);
    println!("📝 目標值: {}", expected.to_lowercase());
    Ok(actual == expected.to_lowercase())
}

fn verify_with_checksum_file(file: &PathBuf, checksum_path: &PathBuf) -> io::Result<bool> {
    let iso_name = file.file_name().unwrap().to_string_lossy();

    let file = File::open(checksum_path)?;
    for line in io::BufReader::new(file).lines() {
        let line = line?;
        let parts: Vec<&str> = line.trim().split_whitespace().collect();
        if parts.len() == 2 && parts[1].ends_with(&*iso_name) {
            return verify_with_hash(file, parts[0]);
        }
    }

    Err(io::Error::new(
        io::ErrorKind::InvalidInput,
        "❌ 錯誤：未在 checksum 檔中找到對應項目",
    ))
}

fn main() -> io::Result<()> {
    let matches = Command::new("verify_iso")
        .version("0.1.0")
        .about("驗證 ISO 檔案的 SHA256 雜湊值")
        .arg(Arg::new("file")
            .short('f')
            .long("file")
            .required(true)
            .value_name("ISO")
            .help("要驗證的 ISO 檔案"))
        .arg(Arg::new("sha256")
            .short('s')
            .long("sha256")
            .value_name("HASH")
            .help("手動提供的 SHA256 雜湊值"))
        .arg(Arg::new("checksum")
            .short('c')
            .long("checksum")
            .value_name("FILE")
            .help("包含雜湊值與檔名的 checksum 檔案"))
        .get_matches();

    let file_path = PathBuf::from(matches.get_one::<String>("file").unwrap());
    let result = if let Some(expected) = matches.get_one::<String>("sha256") {
        verify_with_hash(&file_path, expected)?
    } else if let Some(checksum_path) = matches.get_one::<String>("checksum") {
        verify_with_checksum_file(&file_path, &PathBuf::from(checksum_path))?
    } else {
        eprintln!("❌ 錯誤：請指定 --sha256 或 --checksum");
        std::process::exit(1);
    };

    if result {
        println!("✅ 驗證成功");
        Ok(())
    } else {
        eprintln!("❌ 驗證失敗：雜湊值不一致");
        std::process::exit(2);
    }
}