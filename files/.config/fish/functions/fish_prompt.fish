
function fish_prompt
  set -g last_pipestatus $pipestatus
  set -g last_status $status
  if $_transient_prompt
    fish_transient_prompt
  else
    fish_general_prompt
  end
end

function fish_right_prompt
  if $_transient_prompt
    fish_transient_right_prompt
  else
    fish_general_right_prompt
    set _transient_prompt true
  end
end

function fish_transient_prompt
  set reset_color (printf "\033[m")
  set reset_fg_color (printf "\033[39m")
  
  set -g _transient_prompt_status $last_status
  set -g _transient_prompt_pwd (prompt_pwd)
  set -g _transient_prompt_date (date "+%H:%M:%S")
  
  if [ $_transient_prompt_status = 0 ]
    set status_color (printf "\033[38;5;247m")
  else
    set status_color (printf "\033[38;5;160m")
  end
  
  if [ "$USER" = "root" ]
    set user_symbol ">"
    set user_color (printf "\033[38;5;124m")
  else
    set user_symbol "❯"
    set user_color (printf "\033[38;5;20m")
  end
  
  if [ -w (pwd) ]
    set pwd_color (printf "\033[38;5;214m")
  else
    set pwd_color (printf "\033[38;5;196m")
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
  
  printf "\033[38;5;234m\033[48;5;234m "
  printf "%s" (printf "\033[38;5;129m") $_transient_prompt_date
  printf " \033[48;5;235m\033[38;5;234m "
  printf "%s" $pwd_color $_transient_prompt_pwd
  if _is_git_repo
    printf " \033[48;5;234m\033[38;5;235m "
    printf "%s" $repo_type_color $repo_type
    printf "%s" $reset_fg_color "(" $repo_branch_color $repo_branch $reset_fg_color ")"
    printf "%s" $repo_dirty_color $repo_dirty
    printf " "
    printf "%s" $reset_color
    printf "\033[38;5;234m"
  else
    printf " "
    printf "%s" $reset_color
    printf "\033[38;5;235m"
  end
  
  set right_prompt (_fish_right_prompt)
  set right_prompt_rm_esc (rm_esc_seq "$right_prompt")
  printf "\033[%sG" (math $COLUMNS - (string length "$right_prompt_rm_esc") + 1)
  printf $right_prompt
  
  printf "\n"
  
  printf " "
  printf "%s" $user_color $USER
  printf " "
  printf "%s" $reset_color $status_color $user_symbol $reset_color
  printf " "
end

function fish_general_prompt
  printf "\033[0J\033[90m"
  printf "($_transient_prompt_date)"
  printf ":"
  printf "[$_transient_prompt_pwd]"
  printf "\033[95m>\033[m "
end

function fish_transient_right_prompt
  :
end

function fish_general_right_prompt
  printf "\033[90m"
  printf "[$_transient_prompt_pipestatus]"
  printf ":"
  printf "($_transient_prompt_duration)"
end

function _fish_right_prompt
  set reset_color (printf "\033[m")
  set reset_fg_color (printf "\033[39m")
  
  set -g _transient_prompt_pipestatus $last_pipestatus
  
  if test $CMD_DURATION
    set duration (math $CMD_DURATION / 1000)
    set duration_color (printf "\033[38;5;27m")
  end
  
  set -g _transient_prompt_duration $duration
  
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
  
  printf "\033[38;5;235m\033[48;5;235m "
  printf "%s" $status_style $status_text " " $reset_color
  printf "\033[48;5;235m\033[38;5;234m\033[48;5;234m "
  printf "%s" $duration_color $duration " " $reset_color
  printf "\033[38;5;234m"
  printf "%s" $reset_color
end
