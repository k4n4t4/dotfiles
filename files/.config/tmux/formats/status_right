#!/bin/sh

printf "%s" "\
#[fg=#444444,bg=#222222,nobold,nounderscore,noitalics]#[fg=#eeeeee,bg=#444444,bold]\
\
#{?client_prefix,\
\
#[fg=#00aaee]#[bg=#444444]#[bg=#00aaee]#[fg=#eeeeee]\
#{prefix}\
#[fg=#00aaee]#[bg=#444444]#[fg=#eeeeee]\
\
,}\
\
\
#{?pane_synchronized,\
\
#[fg=#00ee00]#[bg=#444444]#[bg=#00ee00]#[fg=#eeeeee]\
sync\
#[fg=#00ee00]#[bg=#444444]#[fg=#eeeeee]\
\
,}\
\
\
#{?pane_in_mode,\
\
#[fg=#eeaa00]#[bg=#444444]#[bg=#eeaa00]#[fg=#eeeeee]\
mode\
#[fg=#eeaa00]#[bg=#444444]#[fg=#eeeeee]\
\
,}\
 \
"

SHOW_BAT=false
SHOW_MEM=false
SHOW_DATE=true

if $SHOW_BAT; then
  bat_capacity="$(get_battery_info "capacity")"
  bat_status="$(get_battery_info "status")"
  case "$bat_status" in
    ( "Full" )
      bat_status_symbol="~"
      ;;
    ( "Charging" )
      bat_status_symbol="+"
      ;;
    ( "Discharging" )
      bat_status_symbol="-"
      ;;
    ( "Not charging" )
      bat_status_symbol="="
      ;;
    ( * )
      bat_status_symbol="?"
      ;;
  esac
  printf "%s" "#[fg=#eeaeae]🔋:$bat_status_symbol$bat_capacity%#[fg=#999999]|"
fi

if $SHOW_MEM; then
  printf "%s" "#[fg=#aeeeee]🖴 :$(get_mem_rate)%#[fg=#999999]|"
fi

if $SHOW_DATE; then
  printf "%s" "#[fg=#aeaeee]$(date "+%Y-%m-%d %H:%M:%S")"
fi
