if cmd_exists ags; then
  if [ ! -d "$DOT_TARGET_PATH/.config/ags/@girs" ]; then
    msg_run ags init --directory "$DOT_TARGET_PATH/.config/ags" --force
    msg_run rm "$DOT_TARGET_PATH/.config/ags/app.ts"
    msg_run rm "$DOT_TARGET_PATH/.config/ags/style.scss"
    msg_run rm "$DOT_TARGET_PATH/.config/ags/widget/Bar.tsx"
    msg_run rmdir "$DOT_TARGET_PATH/.config/ags/widget"
  fi
  dotconf "ags" -r
fi
