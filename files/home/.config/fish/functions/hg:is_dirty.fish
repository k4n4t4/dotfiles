function hg:is_dirty
  echo (hg status -mard 2> /dev/null)
end
