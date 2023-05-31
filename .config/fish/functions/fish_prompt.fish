
if not set -q -g __fish_robbyrussell_functions_defined
  set -g __fish_robbyrussell_functions_defined
  function _git_branch_name
    set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
    if set -q branch[1]
      echo (string replace -r '^refs/heads/' '' $branch)
    else
      echo (git rev-parse --short HEAD 2>/dev/null)
    end
  end
  function _is_git_dirty
    echo (git status -s --ignore-submodules=dirty 2>/dev/null)
  end
  function _is_git_repo
    type -q git
    or return 1
    git rev-parse --git-dir >/dev/null 2>&1
  end
  function _hg_branch_name
    echo (hg branch 2>/dev/null)
  end
  function _is_hg_dirty
    echo (hg status -mard 2>/dev/null)
  end
  function _is_hg_repo
    fish_print_hg_root >/dev/null
  end
  function _repo_branch_name
    _$argv[1]_branch_name
  end
  function _is_repo_dirty
    _is_$argv[1]_dirty
  end
  function _repo_type
    if _is_hg_repo
        echo 'hg'
        return 0
    else if _is_git_repo
        echo 'git'
        return 0
    end
    return 1
  end
end

function fish_prompt
  set last_status $status
  set user_pwd  (prompt_pwd)
  set user_date (date "+%H:%M:%S")
  
  if [ $USER = "root" ];
    set user_color "\033[31m"
    set user_symbol (printf "\uE0B1")
  else
    set user_color "\033[34m"
    set user_symbol (printf "\uE0B1")
  end
  
  if set repo_type (_repo_type)
    set repo_branch (_repo_branch_name $repo_type)
    if test -n (_is_repo_dirty $repo_type)
      set dirty "!"
    else
      set dirty ""
    end
  end
  
  
  printf "%s" (printf "\033[48;5;240m\033[97m") " " $user_date (printf " \033[m")
  printf "\033[38;5;240m\033[48;5;236m\uE0B0 "
  printf "%s" (printf "\033[48;5;236m\033[97m") $user_pwd (printf " \033[m")
  if [ "$repo_type" != "" ];
    printf "\033[38;5;236m\033[48;5;240m\uE0B0 "

    printf "\033[97m"
    printf $repo_type
    printf "%s" (printf "\033[30m(\033[97m") $repo_branch (printf "\033[30m)")
    if [ "$dirty" != "" ];
      printf "%s" (printf "\033[91m") $dirty
    end
    
    printf " "
    
    printf "\033[m\033[38;5;240m\uE0B4\033[m"
  else
    printf "\033[m\033[38;5;236m\uE0B4\033[m"
  end
  
  
  printf "\n"
  
  printf "%s" \
    (printf $user_color) $USER "@" (prompt_hostname) \
    (printf "\033[m")
  
  printf " "
  
  if [ $last_status -ne 0 ];
    printf "\033[91m"
  else
    printf "\033[93m"
  end
  
  printf "%s" $user_symbol (printf "\033[m")
  
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

