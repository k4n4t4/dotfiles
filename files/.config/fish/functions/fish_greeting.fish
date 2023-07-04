function fish_greeting
  for i in (seq 0 7)
    printf "\033[4%sm  \033[10%sm  " $i $i
  end
  printf "\033[m\n"
end
