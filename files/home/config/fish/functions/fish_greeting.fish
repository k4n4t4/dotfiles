function fish_greeting
    if type -q fastfetch
        if test $COLUMNS -le 80
            fastfetch -c mini
        else
            fastfetch -c full
        end
    end
end
