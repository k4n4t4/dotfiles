#!/bin/sh

printf "%s" "\
#[fg=#222222,bg=#333333]#[fg=#555599,bg=#333333]\
 #{window_index}\
 #[fg=#333333,bg=#555599] #[fg=#eeeeee]\
#{pane_current_command} \
#[fg=#555599,bg=#222222,nobold]\
"
