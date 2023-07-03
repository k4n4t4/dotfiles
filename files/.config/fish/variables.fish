
set -g fish_handle_reflow 0

if type -q exa
export EXA_COLORS="\
ur=38;2;255;255;0:\
uw=38;2;255;0;0:\
ux=38;2;0;255;0:\
ue=1;38;2;0;255;0:\
\
gr=38;2;255;255;120:\
gw=38;2;255;120;120:\
gx=38;2;120;255;120:\
\
tr=38;2;255;255;120:\
tw=38;2;255;120;120:\
tx=38;2;120;255;120:\
\
su=38;2;255;255;0:\
sf=38;2;255;0;255:\
xa=38;2;0;255;255:\
sn=38;5;92:\
sb=38;5;54:\
da=38;5;24:\
\
uu=38;5;155:\
un=38;5;143:\
gu=38;5;155:\
gn=38;5;143:\
\
di=38;5;27:\
fi=38;5;255:\
ln=38;5;87:\
or=38;5;160:\
pi=38;5;154:\
bd=38;5;208:\
cd=38;5;226:\
\
.*=38;2;190;190;190:\
*sh=38;2;120;200;120:\
*rc=38;2;200;200;120:\
*.conf=38;2;200;200;120:\
*.profile=38;2;200;200;120:\
*.lua=38;2;120;120;200:\
*.json=38;2;200;120;50:\
*.vsix=38;2;255;100;100:\
*.log=38;2;150;50;200:\
*license*=38;2;200;100;255:\
*LICENSE*=38;2;200;100;255"
end

export EDITOR="nvim"
export LANG=C

set _power_supply_path "/sys/class/power_supply"
set _battery_path (command find $_power_supply_path | command grep BAT)
set _transient_prompt false
