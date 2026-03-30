# macOS specific settings for fish shell
# /opt/homebrew はmacOS (Apple Silicon) 固有のパスなのでuname不要
if test -d /opt/homebrew
    set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    set -gx PATH /opt/homebrew/opt/git/bin $PATH
else if test -d /usr/local/Homebrew
    set -gx PATH /usr/local/bin /usr/local/sbin $PATH
    set -gx PATH /usr/local/opt/git/bin $PATH
else
    return
end

# mise: Homebrew が vendor_conf.d/mise-activate.fish で自動activateするため不要

# zoxide
if command -v zoxide >/dev/null
    zoxide init fish | source
end
