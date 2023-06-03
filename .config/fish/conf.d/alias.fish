# alias

if type -q nala
  alias apt "sudo nala"
end

if type -q tmux
  alias tmux  "tmux -u"
  abbr --add t     "tmux"
  abbr --add ta    "tmux attach-session"
  abbr --add tat   "tmux attach-session -t"
  abbr --add tnew  "tmux new-session -d"
  abbr --add tnews "tmux new-session -s"
  abbr --add ttree "tmux choose-tree"
  abbr --add tsc   "tmux switch-client"
  abbr --add tsct  "tmux switch-client -t"
  abbr --add tnc   "tmux switch-client -n"
  abbr --add tpc   "tmux switch-client -p"
  abbr --add tlc   "tmux switch-client -l"
  abbr --add tmv   "tmux rename"
  abbr --add tmvt  "tmux rename -t"
  abbr --add tls   "tmux list-sessions"
  abbr --add tlsc  "tmux list-clients"
  abbr --add td    "tmux detach-client"
  abbr --add trm   "tmux kill-session"
  abbr --add trmt  "tmux kill-session -t"
  abbr --add tkill "tmux kill-server"
end

abbr --add '^' "command "
abbr --add c "clear"

abbr --add cd-  "cd -"
abbr --add cd~  "cd ~"
abbr --add cd.  "cd ."
abbr --add cd.. "cd .."
abbr --add pd   "prevd"
abbr --add nd   "nextd"

for i in (seq 9)
  set -l p "./"
  for j in (seq $i)
    set p "$p../"
  end
  alias cd.$i "cd $p"
end

if type -q git
  abbr --add g    "git"
  abbr --add ga   "git add"
  abbr --add gd   "git diff"
  abbr --add gs   "git status"
  abbr --add gp   "git push"
  abbr --add gb   "git branch"
  abbr --add gbd  "git branch -d"
  abbr --add gbfd "git branch -D"
  abbr --add gm   "git merge"
  abbr --add gst  "git status"
  abbr --add gco  "git checkout"
  abbr --add gcob "git checkout -b"
  abbr --add gf   "git fetch"
  abbr --add gc   "git commit"
  abbr --add gr   "git remote"
  abbr --add gbl  "git blame"
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
  alias exa  "exa --icons --git -g -H"
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

abbr --add cls  "clearls"
abbr --add cll  "clearls -Fl"
abbr --add cla  "clearls -Fa"
abbr --add clla "clearls -Fla"
abbr --add cl "cdls"
abbr --add mc "mkcd"

if type -q ranger
  abbr --add r "ranger"
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
  abbr --add vim "nvim"
  abbr --add vi  "nvim"
  abbr --add v   "nvim"
  abbr --add vo  "nvim -o"
  abbr --add VO  "nvim -O"
  abbr --add vp  "nvim -p"
  abbr --add vd  "nvim -d"
  alias vless "/home/linuxbrew/.linuxbrew/Cellar/neovim/0.9.0/share/nvim/runtime/macros/less.sh"
end

if type -q htop
  alias top "htop"
end

alias ed "ed -p (printf \"\033[94m:\033[92m\")"

if type -q xsel
  alias pbcopy "xsel --clipboard --input"
  alias pwdc 'pwd | tr -d "\n" | xsel --clipboard --input'
end


abbr --add h "history"

abbr --add x "exit"
abbr --add q "exit"

if type -q codium && not type -q code
  alias code "codium"
end


alias reboot   "systemctl reboot"
alias poweroff "systemctl poweroff"

abbr --add rbt "reboot"
abbr --add pof "poweroff"

