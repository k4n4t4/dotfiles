if cmd_exists ags; then
    if [ ! -d "$DOT_TARGET_PATH/.config/ags/@girs" ]; then
        _print_run ags init --directory "$DOT_TARGET_PATH/.config/ags" --force
        _print_run rm "$DOT_TARGET_PATH/.config/ags/app.ts"
        _print_run rm "$DOT_TARGET_PATH/.config/ags/style.scss"
        _print_run rm "$DOT_TARGET_PATH/.config/ags/widget/Bar.tsx"
        _print_run rmdir "$DOT_TARGET_PATH/.config/ags/widget"
    fi
    dotconf "ags" -r
fi
