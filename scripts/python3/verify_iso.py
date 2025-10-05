#!/usr/bin/env python3

import argparse
import hashlib
import sys
from pathlib import Path

def compute_sha256(file_path):
    sha256 = hashlib.sha256()
    try:
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(65536), b""):
                sha256.update(chunk)
        return sha256.hexdigest()
    except FileNotFoundError:
        print(f"❌ 錯誤：找不到檔案 {file_path}")
        sys.exit(2)

def verify_with_string(iso_path, expected_hash):
    actual_hash = compute_sha256(iso_path)
    print(f"✅ 計算值: {actual_hash}")
    print(f"📝 目標值: {expected_hash}")
    if actual_hash == expected_hash.lower():
        print("✅ 驗證成功")
        sys.exit(0)
    else:
        print("❌ 驗證失敗：雜湊值不一致")
        sys.exit(3)

def verify_with_checksum_file(iso_path, checksum_file):
    try:
        with open(checksum_file, "r") as f:
            for line in f:
                parts = line.strip().split()
                if len(parts) == 2:
                    hash_val, filename = parts
                    if Path(filename).name == Path(iso_path).name:
                        return verify_with_string(iso_path, hash_val)
        print(f"❌ 錯誤：未在 {checksum_file} 中找到與 {iso_path} 對應的項目")
        sys.exit(4)
    except FileNotFoundError:
        print(f"❌ 錯誤：找不到 checksum 檔案 {checksum_file}")
        sys.exit(2)

def main():
    parser = argparse.ArgumentParser(description="驗證 ISO 檔案的 SHA256 雜湊值")
    parser.add_argument("-f", "--file", required=True, help="ISO 檔案路徑")
    parser.add_argument("-s", "--sha256", help="官方 SHA256 值")
    parser.add_argument("-c", "--checksum", help="checksum 檔案路徑 (.sha256)")
    args = parser.parse_args()

    if not Path(args.file).exists():
        print(f"❌ 錯誤：找不到檔案 {args.file}")
        sys.exit(2)

    if args.sha256:
        verify_with_string(args.file, args.sha256)
    elif args.checksum:
        verify_with_checksum_file(args.file, args.checksum)
    else:
        print("❌ 錯誤：請提供 SHA256 值 (-s) 或 checksum 檔案 (-c)")
        sys.exit(1)

if __name__ == "__main__":
    main()