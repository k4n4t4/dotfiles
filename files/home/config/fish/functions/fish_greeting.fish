function fish_greeting
    set -f show_fastfetch false
    if $show_fastfetch
        if type -q fastfetch
            if test $COLUMNS -le 100
                fastfetch -c mini
            else
                fastfetch -c full
            end
        end
    end
end
