# macOS specific settings for fish shell
if test (uname) = "Darwin"
    # Add Homebrew to PATH
    if test -d /opt/homebrew
        # Apple Silicon Mac
        set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
        set -gx PATH /opt/homebrew/opt/git/bin $PATH
    else if test -d /usr/local/Homebrew
        # Intel Mac
        set -gx PATH /usr/local/bin /usr/local/sbin $PATH
        set -gx PATH /usr/local/opt/git/bin $PATH
    end

    # mise
    if command -v mise >/dev/null
        mise activate fish | source
    end

    # zoxide
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end
end
