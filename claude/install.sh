#!/bin/bash

# ~/.claude 配下にシンボリックリンクを作成します。
# 既存のファイル/ディレクトリがある場合は上書きします。
mkdir -p ~/.claude

# 既存のディレクトリやリンクを削除してからリンク
rm -rf ~/.claude/skills ~/.claude/commands ~/.claude/CLAUDE.md

ln -sv "$PWD/skills" ~/.claude/skills
ln -sv "$PWD/commands" ~/.claude/commands
ln -sv "$PWD/CLAUDE.md" ~/.claude/CLAUDE.md
