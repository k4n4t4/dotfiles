
function get_battery_info
    for arg in $argv
        command cat "$_battery_path/$arg"
    end
end
