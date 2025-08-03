# Linux specific settings for fish shell
if test (uname) = "Linux"
    # Set locale
    set -x LANG ja_JP.UTF-8

    /usr/bin/mise activate fish | source
    starship init fish | source

    # Initialize zoxide
    if command -v zoxide &> /dev/null
    zoxide init fish | source
    end
end
