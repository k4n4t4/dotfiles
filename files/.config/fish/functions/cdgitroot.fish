
function cdgitroot
    if set root_dir (git rev-parse --show-toplevel)
        cd "$root_dir"
    else
        return $status
    end
end
