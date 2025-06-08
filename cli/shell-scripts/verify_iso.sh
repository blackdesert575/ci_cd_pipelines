#!/usr/bin/env bash

# set -euxo pipefail

# 使用說明
usage() {
    echo "用法: $0 -f <iso檔案> [-s <sha256值>] [-c <checksum檔案>]"
    echo "範例:"
    echo "  $0 -f rhel.iso -s abcdef123456..."
    echo "  $0 -f rhel.iso -c rhel.iso.sha256"
    exit 1
}

# 初始化變數
ISO_FILE=""
SHA256_VAL=""
CHECKSUM_FILE=""

# 解析參數
while getopts "f:s:c:" opt; do
  case "$opt" in
    f) ISO_FILE="$OPTARG" ;;
    s) SHA256_VAL="$OPTARG" ;;
    c) CHECKSUM_FILE="$OPTARG" ;;
    *) usage ;;
  esac
done

# 基本檢查
if [[ -z "$ISO_FILE" ]]; then
    echo "❌ 錯誤：必須指定 ISO 檔案 (-f)"
    usage
fi

if [[ ! -f "$ISO_FILE" ]]; then
    echo "❌ 錯誤：找不到檔案 $ISO_FILE"
    exit 2
fi

# 檢查方式 1：提供 SHA256 字串手動比對
if [[ -n "$SHA256_VAL" ]]; then
    echo "🔍 使用 SHA256 值驗證..."
    CALC_HASH=$(sha256sum "$ISO_FILE" | awk '{print $1}')
    echo "✅ 計算值: $CALC_HASH"
    echo "📝 目標值: $SHA256_VAL"
    if [[ "$CALC_HASH" == "$SHA256_VAL" ]]; then
        echo "✅ 驗證成功"
        exit 0
    else
        echo "❌ 驗證失敗：雜湊值不一致"
        exit 3
    fi
fi

# 檢查方式 2：使用 hash 檔案自動驗證
if [[ -n "$CHECKSUM_FILE" ]]; then
    if [[ ! -f "$CHECKSUM_FILE" ]]; then
        echo "❌ 錯誤：找不到 checksum 檔案 $CHECKSUM_FILE"
        exit 2
    fi
    echo "🔍 使用 checksum 檔案驗證..."
    sha256sum -c "$CHECKSUM_FILE"
    exit $?
fi

# 沒指定驗證方法
echo "❌ 錯誤：請提供 SHA256 值 (-s) 或 checksum 檔案 (-c)"
usage