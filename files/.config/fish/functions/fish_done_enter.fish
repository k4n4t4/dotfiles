function fish_done_enter
  if test -z (commandline)
  else
  end
  fish_force_preexec
  commandline -f execute
end
