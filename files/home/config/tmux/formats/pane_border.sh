#!/bin/sh

printf "%s" "\
#[fg=#222222,bg=default]#[fg=#eeeeee,bg=#222222]\
 #{pane_index} \
#[fg=#666666]#[fg=default,bold]\
 #{pane_title} \
#[fg=#666666,nobold]#[fg=#eeeeee]\
 #{pane_current_command} \
#[fg=#222222,bg=default]\
"
