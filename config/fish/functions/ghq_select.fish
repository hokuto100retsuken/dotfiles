function ghq_select
    set -l selected_dir (ghq list -p | fzf --height 40% --layout=reverse)
    if test -n "$selected_dir"
        cd "$selected_dir"
    end
    commandline -f repaint
end
