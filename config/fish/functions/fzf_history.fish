function fzf_history
    history merge # 他のセッションの履歴をマージ
    set -l result (history | fzf --height 40% --layout=reverse --border --info=inline --no-sort --query (commandline -b))
    if test -n "$result"
        commandline -r $result
    end
    commandline -f repaint
end
