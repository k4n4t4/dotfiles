# alias

if type -q nala
  alias apt "sudo nala"
end

if type -q tmux
  alias tmux "tmux -u"
  alias t "tmux"
  alias ta "t a"
  alias tat "ta -t"
  alias tnew "t new -d"
  alias tnews "tnew -s"
  alias ttree "t choose-tree"
  alias tsc "t switch-client"
  alias tsct "tsc -t"
  alias tnc "tsc -n"
  alias tpc "tsc -p"
  alias tlc "tsc -l"
  alias tmv "t rename"
  alias tmvt "tmv -t"
  alias tls "t ls"
  alias tlsc "t lsc"
  alias td "t detach-client"
  alias trm "t kill-session"
  alias trmt "trm -t"
  alias tkill "t kill-server"
end

abbr --add '^' "command "

alias c "clear"

alias d    "cd"
alias d-   "cd -"
alias cd-  "cd -"
alias d~   "cd ~"
alias cd~  "cd ~"
alias d.   "cd ."
alias cd.  "cd ."
alias d..  "cd .."
alias cd.. "cd .."
alias pd   "prevd"
alias pcd  "prevd"
alias nd   "nextd"
alias ncd  "nextd"

for i in (seq 9)
  set -l p "./"
  for j in (seq $i)
    set p "$p../"
  end
  alias d.$i "cd $p"
  alias cd.$i "cd $p"
end

if type -q git
  alias g    "git"
  alias ga   "git add"
  alias gd   "git diff"
  alias gs   "git status"
  alias gp   "git push"
  alias gb   "git branch"
  alias gbd  "git branch -d"
  alias gbfd "git branch -D"
  alias gm   "git merge"
  alias gst  "git status"
  alias gco  "git checkout"
  alias gcob "git checkout -b"
  alias gf   "git fetch"
  alias gc   "git commit"
  alias gr   "git remote"
  alias gbl  "git blame"
end

if type -q exa
  export EXA_COLORS="\
ur=38;2;255;255;0:\
uw=38;2;255;0;0:\
ux=38;2;0;255;0:\
ue=1;38;2;0;255;0:\
\
gr=38;2;255;255;120:\
gw=38;2;255;120;120:\
gx=38;2;120;255;120:\
\
tr=38;2;255;255;120:\
tw=38;2;255;120;120:\
tx=38;2;120;255;120:\
\
su=38;2;255;255;0:\
sf=38;2;255;0;255:\
xa=38;2;0;255;255:\
sn=38;5;92:\
sb=38;5;54:\
da=38;5;24:\
\
uu=38;5;155:\
un=38;5;143:\
gu=38;5;155:\
gn=38;5;143:\
\
di=38;5;27:\
fi=38;5;255:\
ln=38;5;87:\
or=38;5;160:\
pi=38;5;154:\
bd=38;5;208:\
cd=38;5;226:\
\
.*=38;2;190;190;190:\
*sh=38;2;120;200;120:\
*rc=38;2;200;200;120:\
*.conf=38;2;200;200;120:\
*.profile=38;2;200;200;120:\
*.lua=38;2;120;120;200:\
*.json=38;2;200;120;50:\
*.vsix=38;2;255;100;100:\
*.log=38;2;150;50;200"
  alias exa  "exa --icons -g -H"
  alias ls   "exa"
  alias ll   "exa -Fl"
  alias la   "exa -Fa"
  alias lla  "exa -Fla"
  alias l    "exa -F"
  alias lt   "exa -FT"
  alias lta  "exa -FTa"
  alias llt  "exa -FTl"
  alias llta "exa -FTla"
else
  alias l    "ls -F"
  alias ll   "ls -Fl"
  alias la   "ls -Fa"
  alias lla  "ls -Fla"
end

alias cls  "clearls"
alias cll  "clearls -Fl"
alias cla  "clearls -Fa"
alias clla "clearls -Fla"
alias cl "cdls"
alias mc "mkcd"

if type -q ranger
  alias r "ranger"
end

if type -q batcat
  alias bat "batcat"
end

if type -q rg
  alias grep "rg"
end

if type -q fd
  alias find "fd"
end

if type -q zoxide
  zoxide init fish --cmd z | source
end

if type -q thefuck
  eval (thefuck --alias | tr '\n' ';')
  abbr --add f "fuck"
end

alias cp "cp -v"
alias mv "mv -iv"

if type -q trash
  alias rm "trash"
else
  function stopUseRm
    printf "\033[91mStop!\033[m\n\033[36mPlease install \"trash\" command.\033[m\n"
  end
  alias rm "stopUseRm"
end

alias aptup "sudo apt update && sudo apt upgrade"

if type -q nvim
  alias vim "nvim"
  alias vi  "nvim"
  alias v   "nvim"
  alias vo  "nvim -o"
  alias VO  "nvim -O"
  alias vp  "nvim -p"
  alias vd  "nvim -d"
  alias vless "/home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.0/share/nvim/runtime/macros/less.sh"
end

alias ficonfig "nvim ~/.config/fish/config.fish"
alias nvconfig "nvim ~/.config/nvim"

if type -q htop
  alias top "htop"
end

alias ed "ed -p (printf \"\033[94m:\033[92m\")"

if type -q xsel
  alias pbcopy "xsel --clipboard --input"
  alias pwdc 'pwd | tr -d "\n" | xsel --clipboard --input'
end


alias h "history"

alias x "exit"
abbr --add q "exit"

if type -q codium && not type -q code
  alias code "codium"
end


alias reboot   "systemctl reboot"
alias poweroff "systemctl poweroff"

abbr --add rbt "reboot"
abbr --add pof "poweroff"

