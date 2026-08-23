function fish_greeting
    if type -q fastfetch
        if test $COLUMNS -le 100
            fastfetch -c mini
        else
            fastfetch -c full
        end
    end
end
