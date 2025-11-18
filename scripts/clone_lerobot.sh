#!/usr/bin/env bash
set -euo pipefail

SUBMODULE_PATH="lerobot"
SUBMODULE_NAME="lerobot"
REPO_URL="https://github.com/sige0002/lerobot.git"
BRANCH_NAME="develop"

# Git リポジトリ直下で実行していることを確認
if [ ! -d .git ]; then
  echo "✘ This script must be run from the root of the lerobot_pixi Git repository." >&2
  echo "✘ lerobot_pixi リポジトリのルートで実行してください。" >&2
  exit 1
fi

# .gitmodules に lerobot サブモジュールが定義済みか確認
has_submodule=false
if [ -f .gitmodules ]; then
  if git config --file .gitmodules --name-only --get-regexp "submodule\.${SUBMODULE_NAME}\.path" >/dev/null 2>&1; then
    has_submodule=true
  fi
fi

if [ "$has_submodule" = true ]; then
  echo "📦 Updating ${SUBMODULE_PATH} submodule..."
  echo "📦 ${SUBMODULE_PATH} サブモジュールを更新しています..."
  git submodule update --init --recursive "${SUBMODULE_PATH}"
  echo "✔ ${SUBMODULE_PATH} submodule is ready"
  echo "✔ ${SUBMODULE_PATH} サブモジュールの準備ができました"
else
  # サブモジュールでないディレクトリが既にある場合は安全のため停止
  if [ -d "${SUBMODULE_PATH}" ] && [ ! -d "${SUBMODULE_PATH}/.git" ]; then
    echo "✘ Directory ${SUBMODULE_PATH} exists but is not a submodule; please remove or move it before continuing." >&2
    echo "✘ ${SUBMODULE_PATH} ディレクトリが存在しますがサブモジュールではありません。削除または移動してから再実行してください。" >&2
    exit 1
  fi

  echo "📦 Adding ${SUBMODULE_PATH} submodule..."
  echo "📦 ${SUBMODULE_PATH} サブモジュールを追加しています..."
  git submodule add -b "${BRANCH_NAME}" "${REPO_URL}" "${SUBMODULE_PATH}"
  git submodule update --init --recursive "${SUBMODULE_PATH}"
  echo "✔ ${SUBMODULE_PATH} submodule has been added and initialized"
  echo "✔ ${SUBMODULE_PATH} サブモジュールの追加と初期化が完了しました"
fi
