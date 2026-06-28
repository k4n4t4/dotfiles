~~~bash
# Greeter
sudo pacman -S greetd greetd-tuigreet
~~~

~~~/etc/greetd/config.toml
[default_session]
command = "tuigreet --time --remember --remember-session --cmd uwsm start niri.desktop"
user = "greeter"
~~~

~~~bash
sudo systemctl enable greetd
~~~
