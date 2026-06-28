local use_noctalia_shell = true

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- fcitx5 -d")

    if use_noctalia_shell then
        hl.exec_cmd("uwsm app -- noctalia")
        return
    end

    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd("uwsm app -- awww img ~/pers/imgs/wallpaper.png --transition-type center --transition-duration 1")
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- mako")
    hl.exec_cmd("uwsm app -- wl-paste -w cliphist store")
    hl.exec_cmd("uwsm app -- swayosd-server")
    hl.exec_cmd("uwsm app -- /usr/lib/mate-polkit/polkit-mate-authentication-agent-1")
    hl.exec_cmd("pidof hypridle || uwsm app -- hypridle")
end)
