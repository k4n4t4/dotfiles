
set -g fish_handle_reflow 0

export LS_COLORS=(cat /home/kanata/dotfiles/files/.config/fish/LS_COLORS | tr -d "\n")

export EDITOR="nvim"
export LANG=C

set _power_supply_path "/sys/class/power_supply"
set _battery_path (command find $_power_supply_path | command grep BAT)
set _transient_prompt false
