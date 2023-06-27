if type -q nala
  alias apt "sudo nala"
end

if type -q tmux
  alias tmux  "tmux -u"
  abbr --add t      "tmux"
  abbr --add ta     "tmux attach-session"
  abbr --add tat    "tmux attach-session -t"
  abbr --add tnew   "tmux new-session -d"
  abbr --add tnews  "tmux new-session -s"
  abbr --add ttree  "tmux choose-tree"
  abbr --add tcd    "tmux switch-client"
  abbr --add tcdt   "tmux switch-client -t"
  abbr --add tcdn   "tmux switch-client -n"
  abbr --add tcdp   "tmux switch-client -p"
  abbr --add tcdl   "tmux switch-client -l"
  abbr --add tmv    "tmux rename"
  abbr --add tmvt   "tmux rename -t"
  abbr --add tls    "tmux list-sessions"
  abbr --add tlsc   "tmux list-clients"
  abbr --add td     "tmux detach-client"
  abbr --add tcl    "tmux clear-history"
  abbr --add tclear "clear ; tmux clear-history"
  abbr --add trm    "tmux kill-session"
  abbr --add trmt   "tmux kill-session -t"
  abbr --add tkill  "tmux kill-server"
end

abbr --add '^' "command"
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
  alias cd.$i  "cd $p"
  alias cd..$i "cd $p"
  alias .$i    "cd $p"
  alias ..$i   "cd $p"
end

if type -q git
  abbr --add g    "git"
  abbr --add ga   "git add"
  abbr --add gd   "git diff"
  abbr --add gs   "git status"
  abbr --add gst  "git status"
  abbr --add gss  "git status -s"
  abbr --add gp   "git push"
  abbr --add gpl  "git pull"
  abbr --add gb   "git branch"
  abbr --add gbd  "git branch -d"
  abbr --add gbfd "git branch -D"
  abbr --add gm   "git merge"
  abbr --add gco  "git checkout"
  abbr --add gcob "git checkout -b"
  abbr --add gf   "git fetch"
  abbr --add gc   "git commit"
  abbr --add gcm  "git commit -m"
  abbr --add gr   "git remote"
  abbr --add gbl  "git blame"
  alias groot "cdgitroot"
  alias grt "cdgitroot"
end

if type -q exa
  alias exa  "exa --icons --git -g -H -s type"
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
abbr --add cdl "cdls"
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

alias cp "cp -iv"
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
