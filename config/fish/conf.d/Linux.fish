# Linux specific settings for fish shell
# Homebrew のディレクトリがなければ Linux と判断
if test -d /opt/homebrew; or test -d /usr/local/Homebrew
    return
end

# mise
if command -v mise >/dev/null
    mise activate fish | source
end

# zoxide
if command -v zoxide >/dev/null
    zoxide init fish | source
end
