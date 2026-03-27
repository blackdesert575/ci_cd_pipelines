#!/usr/bin/env bash
set -euo pipefail
# IFS=$'\n\t'

# docs: GNU/Bash manual
# https://www.gnu.org/software/bash/manual/bash.html

#variables, flow control constructs, quoting, and functions

echo "list files under PATH: $(pwd) ："

for FILE in *; do
  echo "$FILE"
done

# for FILE in *.txt; do
#   echo "$FILE"
# done

# find . -type f -print0 | while IFS= read -r -d '' FILE; do
#   echo "找到檔案：$FILE"
# done