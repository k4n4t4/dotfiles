~~~bash
# Greeter
sudo pacman -S greetd greetd-tuigreet
sudo systemctl enable greetd
~~~

~~~/etc/greetd/config.toml
[default_session]
command = "tuigreet --time --remember --remember-session"
user = "greeter"
~~~
