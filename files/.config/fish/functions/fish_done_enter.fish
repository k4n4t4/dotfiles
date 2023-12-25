function fish_done_enter
  if test -z (commandline)
    emit fish_preexec
  else
    commandline -f repaint
  end
  commandline -f execute
end
