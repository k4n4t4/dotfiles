
function fish_prompt
  set -f last_pipestatus $pipestatus
  set -f last_status $status
  set -f prompt_date (date "+%H:%M:%S")
  
  set -f reset_color (printf "\033[m")
  set -f reset_fg_color (printf "\033[39m")
  set -f reset_bg_color (printf "\033[49m")
  
  set -f date_color (printf "\033[38;5;129m")
  
  if [ $last_status = 0 ]
    set -f status_color (printf "\033[38;5;247m")
  else
    set -f status_color (printf "\033[38;5;124m")
  end
  
  if [ "$USER" = "root" ]
    set -f user_color (printf "\033[38;5;124m")
  else
    set -f user_color (printf "\033[38;5;20m")
  end
  
  if [ -w (pwd) ]
    set -f pwd_color (printf "\033[38;5;214m")
  else
    set -f pwd_color (printf "\033[38;5;196m")
  end
  
  if set -f repo_type (_repo_type)
    if [ "$repo_type" = "git" ]
      set -f repo_type_color (printf "\033[38;5;240m")
    else
      set -f repo_type_color (printf "\033[38;5;255m")
    end
    
    set -f repo_branch (_repo_branch_name $repo_type)
    if [ "$repo_branch" = "master" ]; or [ "$repo_branch" = "main" ]
      set -f repo_branch_color (printf "\033[38;5;164m")
    else
      set -f repo_branch_color (printf "\033[38;5;75m")
    end
    
    if [ -n (_is_repo_dirty $repo_type) ]
      set -f repo_dirty "!"
      set -f repo_dirty_color (printf "\033[38;5;196m")
    else
      set -f repo_dirty ""
      set -f repo_dirty_color ""
    end
  end
  
  set -f right_prompt (_fish_right_prompt "$last_pipestatus")
  set -f right_prompt_rm_esc (rm_esc_seq "$right_prompt")
  set -f right_prompt (printf "\033[%sG%s" (math $COLUMNS - (string length "$right_prompt_rm_esc") + 1) $right_prompt)
  
  echo -n " "
  echo -n "$user_color"(hostname)"@$USER$reset_fg_color"
  echo -n " "
  echo -n "$date_color$prompt_date$reset_fg_color"
  echo -n " "
  echo -n "$pwd_color"(prompt_pwd)"$reset_fg_color"
  if _is_git_repo
    echo -n " "
    echo -n $repo_type_color$repo_type
    echo -n $reset_fg_color"("$repo_branch_color$repo_branch$reset_fg_color")"
    echo -n $repo_dirty_color$repo_dirty
    echo -n " "
    echo -n $reset_fg_color
  end
  
  echo $right_prompt
  
  echo -n " "
  echo -n "$status_color"(printf "\033[1m")"❱$reset_color"
  echo -n " "
end

function _fish_right_prompt
  set -f last_pipestatus (string split " " $argv[1])
  set -f reset_color (printf "\033[m")
  set -f reset_fg_color (printf "\033[39m")
  
  
  if test $CMD_DURATION
    set -f duration (math $CMD_DURATION / 1000)
    set -f duration_color (printf "\033[38;5;27m")
  end
  
  set -q __fish_prompt_status_generation
    or set -g __fish_prompt_status_generation $status_generation
  if test $__fish_prompt_status_generation = $status_generation
    set -f status_style ""
  else
    set -f status_style (printf "\033[1m")
  end
  set __fish_prompt_status_generation $status_generation
  
  set -f status_text $reset_fg_color
  set -f status_suc_color (printf "\033[38;5;46m")
  set -f status_err_color (printf "\033[38;5;160m")
  set -f status_comma ""
  for s in $last_pipestatus
    if [ $s = 0 ]
      set -f status_text "$status_text$status_comma$status_suc_color$s$reset_fg_color"
    else
      set -f status_text "$status_text$status_comma$status_err_color$s$reset_fg_color"
    end
    set -f status_comma ","
  end
  
  echo -n $status_style$status_text$reset_fg_color
  echo -n " "
  echo -n $duration_color$duration$reset_fg_color
  echo -n $reset_color
  echo -n " "
end
