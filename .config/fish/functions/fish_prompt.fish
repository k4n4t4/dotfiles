
function fish_prompt
  set last_status $status
  
  if [ $last_status = 0 ]
    set user_status_color (printf "\033[38;5;226m")
  else
    set user_status_color (printf "\033[38;5;160m")
  end
  
  set reset_color (printf "\033[m")
  set reset_fg_color (printf "\033[39m")
  set reset_bg_color (printf "\033[49m")
  
  set user_pwd (prompt_pwd)
  if [ -w (pwd) ]
    set user_pwd_color (printf "\033[38;5;214m")
  else
    set user_pwd_color (printf "\033[38;5;196m")
  end
  
  set user_date (date "+%H:%M:%S")
  set user_date_color (printf "\033[38;5;129m")
  
  if [ "$USER" = "root" ]
    set user_symbol "#"
    set user_color (printf "\033[38;5;196m")
  else
    set user_symbol "\$"
    set user_color (printf "\033[38;5;63m")
  end
  
  if set repo_type (_repo_type)
    if [ "$repo_type" = "git" ]
      set repo_type_color (printf "\033[38;5;232m")
    else
      set repo_type_color (printf "\033[38;5;255m")
    end
    
    set repo_branch (_repo_branch_name $repo_type)
    if [ "$repo_branch" = "master" ] || [ "$repo_branch" = "main" ]
      set repo_branch_color (printf "\033[38;5;164m")
    else
      set repo_branch_color (printf "\033[38;5;75m")
    end
    
    if [ -n (_is_repo_dirty $repo_type) ]
      set repo_dirty "!"
      set repo_dirty_color (printf "\033[38;5;196m")
    else
      set repo_dirty ""
      set repo_dirty_color ""
    end
  end
  
  printf "\033[48;5;236m"
  
  printf " "
  
  printf "%s" $user_date_color $user_date
  printf " "
  
  printf "\033[48;5;238m\033[38;5;236m"
  printf ""
  
  printf " "
  
  printf "%s" $user_color $USER "@" (prompt_hostname)
  printf " "
  
  printf "\033[48;5;236m\033[38;5;238m"
  printf ""
  printf " "
  
  printf "%s" $user_pwd_color $user_pwd
  printf " "
  
  if _is_git_repo
    
    printf "\033[48;5;238m\033[38;5;236m"
    printf ""
    printf " "
    
    printf "%s" $repo_type_color $repo_type
    printf "%s" $reset_fg_color "(" $repo_branch_color $repo_branch $reset_fg_color ")"
    printf "%s" $repo_dirty_color $repo_dirty
    
    printf " "
    printf "%s" $reset_color
    printf "\033[38;5;238m"
    printf ""
    
  else
    printf "%s" $reset_color
    printf "\033[38;5;236m"
    printf ""
  end
  
  printf "\n"
  
  printf "%s" $reset_color $user_status_color $user_symbol $reset_color
  printf " "

end

function fish_right_prompt
  
  set -l last_pipestatus $pipestatus
  set -lx __fish_last_status $status
  
  set -q fish_color_status
  or set -g fish_color_status --background=red white

  set -l bold_flag --bold
  set -q __fish_prompt_status_generation; or set -g __fish_prompt_status_generation $status_generation
  if test $__fish_prompt_status_generation = $status_generation
      set bold_flag
  end
  set __fish_prompt_status_generation $status_generation
  set -l status_color (set_color $fish_color_status)
  set -l statusb_color (set_color $bold_flag $fish_color_status)
  set -l prompt_status (__fish_print_pipestatus "[" "]" "|" "$status_color" "$statusb_color" $last_pipestatus)
  
  printf "%s%s%s" \
    (set_color white) \
    $prompt_status \
    (set_color white)
  if test $CMD_DURATION
    set duration (printf "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
    printf "[%s%s%s]" \
      (set_color brblue) \
      $duration \
      (set_color white)
  end
end

