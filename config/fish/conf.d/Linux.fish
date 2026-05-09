# Linux specific settings for fish shell
# Homebrew のディレクトリがなければ Linux と判断
if test -d /opt/homebrew; or test -d /usr/local/Homebrew
    return
end
