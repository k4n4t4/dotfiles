function clear
  if [ (count $argv) -ne 0 ]
    command clear && cd $argv
  else
    command clear
  end
end
