#!/bin/sh
set -eu

width=80%
height=80%

if [ "$(tmux display -p -F "#{session_name}")" = "popup" ]; then
    tmux detach-client
else
    tmux popup -d "#{pane_current_path}" -x C -y C -w $width -h $height -E "tmux attach -t popup || tmux new -s popup"
fi

