function cdgitroot
  if set -l root_dir (git rev-parse --show-toplevel)
    cd $root_dir
  else
    return $status
  end
end
