# macOS specific settings for fish shell
if test -d /opt/homebrew
    set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
    set -gx PATH /opt/homebrew/opt/git/bin $PATH
else if test -d /usr/local/Homebrew
    set -gx PATH /usr/local/bin /usr/local/sbin $PATH
    set -gx PATH /usr/local/opt/git/bin $PATH
end
