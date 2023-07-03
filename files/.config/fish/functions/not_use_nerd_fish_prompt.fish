
function fish_prompt
  set last_status $status
  
  if ! $_transient_prompt
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
        set repo_type_color (printf "\033[38;5;240m")
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
    
    printf "\033[38;5;239m"
    yes "─" | head -n $COLUMNS | tr -d "\n"
    printf "\033[m\r"
    
    printf "\033[48;5;234m "
    
    printf "%s" $user_date_color $user_date
    
    printf " \033[48;5;235m\033[38;5;234m "
    
    printf "%s" $user_pwd_color $user_pwd
    
    if _is_git_repo
      printf " \033[48;5;234m\033[38;5;235m "
      
      printf "%s" $repo_type_color $repo_type
      printf "%s" $reset_fg_color "(" $repo_branch_color $repo_branch $reset_fg_color ")"
      printf "%s" $repo_dirty_color $repo_dirty
      
      printf " "
      
      printf "%s" $reset_color
      printf "\033[38;5;234m"
    else
      printf " "
      printf "%s" $reset_color
      printf "\033[38;5;235m"
    end
    
    printf "\n"
    
    printf "%s" $user_color $USER "@" (prompt_hostname)
    printf " "
    
    printf "%s" $reset_color $user_status_color $user_symbol $reset_color
    printf " "
  else
    printf "\033[0J\033[95m>\033[m "
  end
end

function fish_right_prompt
  
  set last_pipestatus $pipestatus
  set last_status $status
  
  if ! $_transient_prompt
    set reset_color (printf "\033[m")
    set reset_fg_color (printf "\033[39m")
    set reset_bg_color (printf "\033[49m")
    
    set -q __fish_prompt_status_generation
      or set -g __fish_prompt_status_generation $status_generation
    
    if test $__fish_prompt_status_generation = $status_generation
      set status_style ""
    else
      set status_style (printf "\033[1m")
    end
    
    set __fish_prompt_status_generation $status_generation
    
    set status_text $reset_fg_color
    set status_suc_color (printf "\033[38;5;46m")
    set status_err_color (printf "\033[38;5;160m")
    set status_comma ""
    for s in $last_pipestatus
      if [ $s = 0 ]
        set status_text "$status_text$status_comma$status_suc_color$s$reset_fg_color"
      else
        set status_text "$status_text$status_comma$status_err_color$s$reset_fg_color"
      end
      set status_comma ","
    end
    
    if test $CMD_DURATION
      set duration (printf "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
      set duration_color (printf "\033[38;5;27m")
    end
    
    printf "\033[A"
    
    printf "\033[38;5;235m\033[48;5;235m "
    printf "%s" $status_style $status_text " " $reset_color
    
    if test $CMD_DURATION
      printf "\033[48;5;235m\033[38;5;234m\033[48;5;234m "
      printf "%s" $duration_color $duration " " $reset_color
    end
    
    printf "\033[B"
  else
    set _transient_prompt false
  end
  
end

