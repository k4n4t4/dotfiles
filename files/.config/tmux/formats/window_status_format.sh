#!/bin/sh

printf "%s" "\
#[fg=#222222,bg=#333333]#[fg=#666666,bg=#333333]\
 #{window_index}\
  \
#{pane_current_command} \
#[fg=#333333,bg=#222222,nobold,nounderscore,noitalics]\
"
