# aliases
alias l = ls
alias ll = ls --long
alias la = ls --all
alias lla = ls --long --all

alias c = clear
alias q = exit

alias v = nvim

# starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
