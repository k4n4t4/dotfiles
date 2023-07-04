
set -g fish_handle_reflow 0

export LS_COLORS=(get_ls_colors)

export EDITOR="nvim"
export LANG=C

set _power_supply_path "/sys/class/power_supply"
set _battery_path (command find $_power_supply_path | command grep BAT)
set _transient_prompt false
