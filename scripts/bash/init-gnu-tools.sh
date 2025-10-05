#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------------------------
# macOS GNU tools bootstrapper
# - Installs Homebrew if missing
# - Installs GNU toolchain (coreutils, gnu-sed, grep, gawk, findutils, gnu-tar, make, bash, diffutils, moreutils)
# - Adds gnubin paths to shell rc files (~/.zshrc, ~/.bashrc) idempotently
# - Optionally sets default login shell to Homebrew bash (--set-bash-default)
# ------------------------------------------------------------------------------

WANT_SET_BASH_DEFAULT=false
if [[ "${1:-}" == "--set-bash-default" ]]; then
  WANT_SET_BASH_DEFAULT=true
fi

# Detect brew prefix (Intel vs Apple Silicon)
detect_brew_prefix() {
  if command -v brew >/dev/null 2>&1; then
    brew --prefix
  else
    # Guess by arch; will be corrected after install
    if [[ "$(uname -m)" == "arm64" ]]; then
      echo "/opt/homebrew"
    else
      echo "/usr/local"
    fi
  fi
}

BREW_PREFIX="$(detect_brew_prefix)"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  echo "🟡 Homebrew 未安裝，開始安裝..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Set brew to current shell
  if [[ -d "/opt/homebrew/bin" ]]; then
    BREW_PREFIX="/opt/homebrew"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "${HOME}/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/bin" ]]; then
    BREW_PREFIX="/usr/local"
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "${HOME}/.zprofile"
    eval "$(/usr/local/bin/brew shellenv)"
  fi
else
  echo "✅ Homebrew 已安裝：$(brew --version | head -n1)"
  BREW_PREFIX="$(brew --prefix)"
fi

# Packages to install (names are Homebrew formulae)
PKGS=(
  coreutils
  gnu-sed
  grep
  gawk
  findutils
  gnu-tar
  make
  bash
  diffutils
  moreutils
)

echo "🔧 安裝/更新 GNU 套件：${PKGS[*]}"
brew update >/dev/null
brew install "${PKGS[@]}" || true
brew upgrade "${PKGS[@]}" || true

# Build gnubin PATH list
GNUBIN_DIRS=()
# Many GNU formulae ship "gnubin" shims that provide unprefixed names
for f in coreutils gnu-sed grep findutils; do
  if [[ -d "${BREW_PREFIX}/opt/${f}/libexec/gnubin" ]]; then
    GNUBIN_DIRS+=("${BREW_PREFIX}/opt/${f}/libexec/gnubin")
  fi
done

# Compose PATH export lines
PATH_LINES=()
for d in "${GNUBIN_DIRS[@]}"; do
  PATH_LINES+=("export PATH=\"${d}:\$PATH\"")
done

# Helper: append a line to rc file only if not already present
append_once() {
  local line="$1"
  local file="$2"
  touch "$file"
  # Use fixed-string grep (-F) to avoid regex interpretation
  if ! grep -Fq "$line" "$file"; then
    printf "\n%s\n" "$line" >> "$file"
    echo "  ➕ 已寫入：$file :: $line"
  else
    echo "  ↔️  已存在：$file :: $line"
  fi
}

# Update rc files (zsh is default on modern macOS)
RC_FILES=()
[[ -n "${ZDOTDIR:-}" ]] && RC_FILES+=("${ZDOTDIR}/.zshrc")
RC_FILES+=("${HOME}/.zshrc" "${HOME}/.bashrc")

echo "🧩 寫入 PATH 到 rc 檔案..."
for rc in "${RC_FILES[@]}"; do
  for line in "${PATH_LINES[@]}"; do
    append_once "$line" "$rc"
  done
done

# Also ensure brew shellenv is evaluated in zprofile for login shells
ZPROFILE="${HOME}/.zprofile"
if ! grep -Fq 'brew shellenv' "$ZPROFILE" 2>/dev/null; then
  if [[ -x "${BREW_PREFIX}/bin/brew" ]]; then
    echo "eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\"" >> "$ZPROFILE"
    echo "  ➕ 已寫入：$ZPROFILE :: eval \"\$(${BREW_PREFIX}/bin/brew shellenv)\""
  fi
fi

# Optionally set default shell to Homebrew bash
if $WANT_SET_BASH_DEFAULT; then
  HOMEBREW_BASH="${BREW_PREFIX}/bin/bash"
  if [[ -x "$HOMEBREW_BASH" ]]; then
    echo "🖥️ 切換預設 shell 到 Homebrew bash（需要 sudo）..."
    if ! grep -Fxq "$HOMEBREW_BASH" /etc/shells; then
      echo "  ➕ 將 $HOMEBREW_BASH 加入 /etc/shells"
      sudo bash -c "echo '$HOMEBREW_BASH' >> /etc/shells"
    fi
    # Change shell for current user
    chsh -s "$HOMEBREW_BASH"
    echo "✅ 預設 shell 已切換為：$HOMEBREW_BASH"
  else
    echo "⚠️ 找不到 Homebrew bash：$HOMEBREW_BASH"
  fi
else
  echo "ℹ️ 省略切換預設 shell。如需切換，改用：$0 --set-bash-default"
fi

# Verification
echo
echo "🔎 版本驗證（執行新 shell 前先臨時 export PATH）："
TMP_PATH="$(IFS=:; echo "${GNUBIN_DIRS[*]}")"
export PATH="${TMP_PATH}:$PATH"

# Show versions
set +e
echo "ls:        $(ls --version 2>/dev/null | head -n1 || echo 'BSD ls (無 --version，代表目前仍為系統版)')"
echo "sed:       $(sed --version 2>/dev/null | head -n1 || sed -V 2>/dev/null | head -n1 || echo 'BSD sed')"
echo "grep:      $(grep --version 2>/dev/null | head -n1 || echo 'BSD grep')"
echo "find:      $(find --version 2>/dev/null | head -n1 || echo 'BSD find')"
echo "gdate:     $(gdate --version 2>/dev/null | head -n1 || echo '未安裝？（來自 coreutils）')"
echo "bash:      $(bash --version 2>/dev/null | head -n1)"
set -e

echo
echo "✅ 完成！請開一個新的終端視窗（或執行 'exec \$SHELL'）以套用 PATH。"
echo "   之後 'ls/sed/grep/find/date' 等將使用 GNU 版本（透過 gnubin）。"