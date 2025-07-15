# Linux specific settings for fish shell
if test (uname) = "Linux"
    /home/hkt100rtkn/.local/bin/mise activate fish | source
    starship init fish | source
end
