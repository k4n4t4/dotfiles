#!/bin/sh

printf "%s" "\
#[fg=#eeeeee,bg=#333333,bold]\
 #{session_name} \
#[fg=#333333,bg=#444444,nobold,nounderscore,noitalics]#[fg=#eeeeee,bg=#444444,bold]\
 #{user}@#{host} \
#[fg=#444444,bg=#222222]\
"
