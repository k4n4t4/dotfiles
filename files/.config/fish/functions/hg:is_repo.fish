function hg:is_repo
  type -q hg
  or return 1
  fish_print_hg_root > /dev/null 2>&1
end
