function fish_greeting
  printf "\n  "
  for i in (seq 0 7)
    printf "\033[4%sm  \033[m  \033[10%sm  \033[m  " $i $i
  end
  printf "\033[m\n\n"
end
