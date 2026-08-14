function wt --description "ブランチごとの git worktree を作って行き来する"
    set -l script $HOME/.claude/skills/worktree/scripts/wt.sh

    if not test -x $script
        echo "wt.sh が見つかりません: $script" >&2
        return 1
    end

    switch "$argv[1]"
        case add
            $script $argv; or return $status
            # 作ったらそのまま移動する
            cd ($script path $argv[2])

        case cd
            # 引数があればその worktree へ、なければ fzf で選ぶ
            if test (count $argv) -gt 1
                cd ($script path $argv[2])
            else
                set -l target (git worktree list | fzf --height 40% --layout=reverse | awk '{print $1}')
                test -n "$target"; and cd $target
            end

        case ''
            $script

        case '*'
            $script $argv
    end
end
