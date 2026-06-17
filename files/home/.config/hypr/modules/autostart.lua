hl.on("hyprland.start", function()
    -- fcitx5
    hl.exec_cmd("uwsm app -- fcitx5 -d")

    -- awww
    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd("uwsm app -- awww img ~/pers/imgs/wallpaper.png --transition-type center --transition-duration 1")

    -- waybar
    hl.exec_cmd("uwsm app -- waybar")

    -- mako
    hl.exec_cmd("uwsm app -- mako")

    -- wl-clipboard
    hl.exec_cmd("uwsm app -- wl-paste -w cliphist store")

    -- -- noctalia shell
    -- hl.exec_cmd("uwsm app -- qs -c noctalia-shell")

    -- swayosd
    hl.exec_cmd("uwsm app -- swayosd-server")

    -- polkit
    hl.exec_cmd("uwsm app -- /usr/lib/mate-polkit/polkit-mate-authentication-agent-1")

    -- hypridle
    hl.exec_cmd("pidof hypridle || uwsm app -- hypridle")
end)
