#!/bin/bash

# ~/.claude/skills へのシンボリックリンクを作成します。
mkdir -p ~/.claude
ln -sfv $PWD/skills ~/.claude/skills
