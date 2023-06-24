
function get_mem_info
    for arg in $argv
        command cat /proc/meminfo | command grep -E "$arg" | awk '{print $2}'
    end
end
