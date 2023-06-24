
function get_cpu_info
    for arg in $argv
        command cat /proc/stat | command grep -E "$arg"
    end
end
