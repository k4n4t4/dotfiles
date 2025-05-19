function clear
  if test (count $argv) -ne 0
    command clear && cd $argv
  else
    command clear
  end
end
