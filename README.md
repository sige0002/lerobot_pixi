# lerobot_pixi

LeRobot 用の Pixi 管理環境です。Pi Zero 系ロボット向けのセットアップと、NVIDIA Isaac GR00T (CUDA 対応 Linux) 向けのセットアップを同じリポジトリで切り替えられるように構成しています。

## 事前準備

- [Pixi](https://pixi.sh/latest/) をホスト環境にインストールしてください。
- GR00T 環境を使う場合は CUDA 対応 Linux マシンを用意し、適切な NVIDIA ドライバーと CUDA Toolkit (`CUDA_HOME` が設定済み) をインストールしてください。

## サブモジュールの取得

```bash
pixi run clone_lerobot
```

初回は `lerobot` サブモジュールが自動的に追加・初期化されます。既に存在する場合は最新状態まで更新されます。

## 環境の切り替え

`pixi.toml` には以下の 2 つの環境が定義されています。

| 環境名 | 主な用途 | 有効化される extras / 依存 |
| --- | --- | --- |
| `pi0` (デフォルト) | Pi Zero + Feetech サーボ構成 | `lerobot[feetech,pi]` |
| `groot` | NVIDIA Isaac GR00T N1.5 実行用 (CUDA) | `lerobot[groot]`, PyTorch, FlashAttention 依存 |

切り替え例:

```bash
# Pi Zero 用環境を構築
pixi install --environment pi0

# GR00T 用環境を構築 (CUDA Linux 上で)
pixi install --environment groot

# 任意環境のシェルに入る
pixi shell --environment groot   # or pi0
```

## GR00T (CUDA) 環境の追加手順

1. CUDA 対応 Linux 上で `pixi install --environment groot` を実行します。PyTorch の CUDA wheel を使う場合は `pixi config set pypi.extra-index-url https://download.pytorch.org/whl/cu1XX` などでインデックスを追加してください。
2. FlashAttention をインストール:
   ```bash
   pixi run --environment groot install_flash_attn
   ```
   成功には `nvcc` と `CUDA_HOME` の設定が必要です。
3. Lerobot (groot extra) は環境内で自動的に editable インストールされています。必要に応じて `pixi run --environment groot <task>` でタスクを実行してください。

## Pi Zero 用環境の利用

```bash
pixi install --environment pi0
pixi shell --environment pi0
```

Pi Zero 向けの extras (`feetech`, `pi`) が有効になった状態で lerobot が editable インストールされます。

## 便利なタスク

| タスク名 | 説明 |
| --- | --- |
| `clone_lerobot` | `lerobot` サブモジュールの追加・更新 |
| `install_flash_attn` | FlashAttention を CUDA 環境にインストール (`groot` 環境向け) |

タスクは `pixi run [--environment ENV] <task>` で実行できます。

## Git への push

このリポジトリを GitHub (`https://github.com/sige0002/lerobot_pixi.git`) に push する場合は、`git remote add origin` の設定後に通常通り `git add`, `git commit`, `git push origin main` を行ってください。
