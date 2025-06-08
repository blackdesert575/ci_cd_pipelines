#!/usr/bin/env bash
set -euxo pipefail

# 設定固定的專案根目錄 (ci_cd_pipelines)
PROJECT_ROOT="$HOME/repos/ci_cd_pipelines"

# 切換到專案根目錄
cd "$PROJECT_ROOT"

# 設定 Dockerfile 和 Python CLI 腳本的路徑
DOCKER_DIR="$PROJECT_ROOT/docker"
DOCKERFILE="$DOCKER_DIR/Dockerfile.python_cli"
PYTHON_CLI_SCRIPT="$DOCKER_DIR/docker_tool.py"

# 確保 Dockerfile 和 Python 腳本存在
if [[ ! -f "$DOCKERFILE" ]]; then
    echo "❌ 錯誤: 找不到 Dockerfile.python_cli ($DOCKERFILE)"
    exit 1
fi

if [[ ! -f "$PYTHON_CLI_SCRIPT" ]]; then
    echo "❌ 錯誤: 找不到 docker_tool.py ($PYTHON_CLI_SCRIPT)"
    exit 1
fi

# 構建 Docker 映像
docker build -t python3-ci-tools -f "$DOCKERFILE" "$DOCKER_DIR"

echo "✅ Docker 映像 python3-ci-tools 構建完成！"