# config
$env.config.show_banner = false
$env.config.keybindings ++= [
  {
    name: abbr
    modifier: control
    keycode: space
    mode: [emacs, vi_normal, vi_insert]
    event: [
      { send: menu name: abbr_menu }
      { edit: insertchar, value: ' '}
    ]
  }
]
$env.config.edit_mode = 'vi'

# environment variables
$env.EDITOR = "nvim"
