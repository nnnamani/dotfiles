# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## リポジトリ概要

このリポジトリは、chezmoiで管理されている個人のdotfilesで、クロスプラットフォーム（macOS/Linux）の開発環境設定を含んでいます。

## 主要コマンド

### Chezmoi操作
- `chezmoi apply` - dotfilesをシステムに適用
- `chezmoi diff` - 適用される変更を表示
- `chezmoi status` - 管理されているファイルの状態を表示
- `chezmoi edit <file>` - 管理されているファイルを編集（例：`chezmoi edit ~/.zshrc`）
- `chezmoi cd` - ソースディレクトリに移動
- `chezmoi update` - gitから変更をプル・適用

### テンプレートシステム
`.tmpl`拡張子のファイルは、chezmoiテンプレートシステムを使用し、OS別の条件分岐を含みます：
- `{{ if eq .chezmoi.os "darwin" }}` - macOS固有の設定
- `{{ if eq .chezmoi.os "linux" }}` - Linux固有の設定

## アーキテクチャ

### 設定ファイル構造
- `dot_config/` - `~/.config/`ディレクトリにマップ
  - `alacritty/` - 豊富なキーボードバインディングを持つターミナルエミュレータ設定
  - `fish/` - starshipプロンプト統合のFishシェル設定
  - `tmux/` - カスタムプレフィックス（C-q）とプラグインを持つターミナルマルチプレクサ
- `dot_vimrc` - 日本語コメント付きVim設定
- `dot_zshrc.tmpl` - クロスプラットフォーム対応の包括的zsh設定

### 主要機能
- **マルチシェル対応**: zshとfishの両方の設定
- **開発ツール統合**: asdf、mise、pyenv、cargo、goツールチェーン
- **ターミナル設定**: Alacritty + tmuxのカスタムキーバインディング
- **バージョン管理**: 複数言語のバージョン管理ツール対応
- **カスタム関数**: fzfを使ったGitブランチ切り替え、履歴検索
- **クロスプラットフォーム対応**: macOS/Linux用の条件分岐設定

### ツールスタック
- **ターミナル**: HackGen Console NFフォントのAlacritty
- **シェル**: zsh（メイン）+ zplugプラグイン管理、fish（サブ）
- **マルチプレクサ**: tmux + TPM（Tmux Plugin Manager）
- **プロンプト**: starship
- **検索**: 全体的なfzf統合
- **バージョン管理**: asdf、mise、pyenv
- **エディタ**: vim、emacsデーモン対応

テンプレートを変更する際は、必ずOS条件分岐ロジックを保持し、テンプレート構文が壊れないことを確認してください。
