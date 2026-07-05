if cmd_exists navi; then
    dothome ".config/navi/cheats" "$TARGET_PATH/.local/share/navi/cheats/mycheats"
    dotconf "navi" -r -i "cheats"
fi
