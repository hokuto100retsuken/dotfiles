# macOS specific settings for fish shell
if test (uname) = "Darwin"
    # Add Homebrew to PATH
    if test -d /opt/homebrew
        # Apple Silicon Mac
        set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH
        # Use Homebrew's git instead of system git
        set -gx PATH /opt/homebrew/opt/git/bin $PATH
    else if test -d /usr/local/Homebrew
        # Intel Mac
        set -gx PATH /usr/local/bin /usr/local/sbin $PATH
        # Use Homebrew's git instead of system git
        set -gx PATH /usr/local/opt/git/bin $PATH
    end

    # Homebrew completions
    if test -d /opt/homebrew/share/fish/vendor_completions.fish
        source /opt/homebrew/share/fish/vendor_completions.fish
    else if test -d /usr/local/share/fish/vendor_completions.fish
        source /usr/local/share/fish/vendor_completions.fish
    end

    # mise setup for macOS
    if test -d /opt/homebrew/bin/mise
        /opt/homebrew/bin/mise activate fish | source
    else if test -d /usr/local/bin/mise
        /usr/local/bin/mise activate fish | source
    end

    # starship setup
    starship init fish | source
end
