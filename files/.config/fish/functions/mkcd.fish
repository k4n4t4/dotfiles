function mkcd
    mkdir -p -- $argv && builtin cd -- $argv
end
