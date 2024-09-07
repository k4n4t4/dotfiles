fish_add_path \
  "$HOME/bin" \
  "$HOME/go/bin" \
  "$HOME/.cargo/bin" \
  "$HOME/.local/bin" \
  "/snap/bin" \
  "/usr/sandbox" \
  "/usr/local/bin" \
  "/usr/share/games" \
  "/usr/local/sbin" \
  "/usr/sbin" \
  "/sbin"

if test -f /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
