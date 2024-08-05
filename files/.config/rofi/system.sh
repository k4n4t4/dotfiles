#!/bin/sh

if [ $# -eq 0 ]; then
  echo "Lock"
  echo "Quit"
  echo "Restart"
  echo "Poweroff"
  echo "Reboot"
else
  case "$1" in
    ( "Lock" )
      notify-send "lock"
      ;;
    ( "Quit" )
      notify-send "quit"
      bspc quit
      ;;
    ( "Restart" )
      notify-send "restart"
      bspc wm -r
      ;;
    ( "Poweroff" )
      notify-send "poweroff"
      poweroff
      ;;
    ( "Reboot" )
      notify-send "reboot"
      reboot
      ;;
  esac
fi
