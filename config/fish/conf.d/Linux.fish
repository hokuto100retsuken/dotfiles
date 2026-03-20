# Linux specific settings for fish shell
if test (uname) = "Linux"
    # mise
    if command -v mise >/dev/null
        mise activate fish | source
    end

    # zoxide
    if command -v zoxide >/dev/null
        zoxide init fish | source
    end
end
