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

abbr --add h "history"
abbr --add q "exit"

alias reboot   "systemctl reboot"
alias poweroff "systemctl poweroff"
abbr --add rbt "reboot"
abbr --add pof "poweroff"


if type -q tmux
  alias tmux "tmux -u"
  abbr --add tm      "tmux"
  abbr --add tma     "tmux attach-session"
  abbr --add tmat    "tmux attach-session -t"
  abbr --add tmnew   "tmux new-session -d"
  abbr --add tmnews  "tmux new-session -s"
  abbr --add tmtree  "tmux choose-tree"
  abbr --add tmcd    "tmux switch-client"
  abbr --add tmcdt   "tmux switch-client -t"
  abbr --add tmcdn   "tmux switch-client -n"
  abbr --add tmcdp   "tmux switch-client -p"
  abbr --add tmcdl   "tmux switch-client -l"
  abbr --add tmmv    "tmux rename"
  abbr --add tmmvt   "tmux rename -t"
  abbr --add tmls    "tmux list-sessions"
  abbr --add tmlsc   "tmux list-clients"
  abbr --add tmd     "tmux detach-client"
  abbr --add tmcl    "tmux clear-history"
  abbr --add tmclear "clear ; tmux clear-history"
  abbr --add tmrm    "tmux kill-session"
  abbr --add tmrmt   "tmux kill-session -t"
  abbr --add tmkill  "tmux kill-server"
end

if type -q git
  abbr --add g    "git"
  abbr --add ga   "git add"
  abbr --add gd   "git diff"
  abbr --add gdc  "git diff --cached"
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
  abbr --add gcmu "git commit -m update"
  abbr --add gcmau "git add . && git commit -m update"
  abbr --add gcmaup "git add . && git commit -m update && git push"
  abbr --add gr   "git remote"
  abbr --add gbl  "git blame"
  alias groot "cdgitroot"
end

if type -q eza
  alias eza   "eza --icons --git -H --sort=type --time-style=long-iso"
  alias ls    "eza"
  alias ll    "eza -F -l"
  alias la    "eza -F -a"
  alias lla   "eza -F -la"
  alias l     "eza -F"
  alias lt    "eza -F -T"
  alias lta   "eza -F -Ta"
  alias llt   "eza -F -Tl"
  alias llta  "eza -F -Tla"
  alias lll   "eza -F -l -igbhHSOM@ --git-repos"
  alias llla  "eza -F -la -igbhHSOM@ --git-repos"
  alias lllt  "eza -F -Tl -igbhHSOM@ --git-repos"
  alias lllta "eza -F -Tla -igbhHSOM@ --git-repos"
else if type -q exa
  alias exa  "exa --icons --git -H -s type --time-style=long-iso"
  alias ls   "exa"
  alias ll   "exa -Fl"
  alias la   "exa -Fa"
  alias lla  "exa -Fla"
  alias l    "exa -F"
  alias lt   "exa -FT"
  alias lta  "exa -FTa"
  alias llt  "exa -FTl"
  alias llta "exa -FTla"
  export EXA_COLORS=(get_ls_colors exa)
else if type -q lsd
  alias ls   "lsd"
  alias ll   "lsd -Fl"
  alias la   "lsd -Fa"
  alias lA   "lsd -FA"
  alias lla  "lsd -Fla"
  alias llA  "lsd -FlA"
  alias l    "lsd -F"
  alias lt   "lsd -F --tree"
  alias lta  "lsd -Fa --tree"
  alias llt  "lsd -Fl --tree"
  alias llta "lsd -Fla --tree"
else
  alias l   "ls -F"
  alias ll  "ls -Fl"
  alias la  "ls -Fa"
  alias lla "ls -Fla"
  export LS_COLORS=(get_ls_colors)
end

if type -q zoxide
  zoxide init fish --cmd z | source
end

if type -q broot
  broot --print-shell-function fish | source
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
  function _stopUseRm
    printf "\033[91mStop!\033[m\n\033[36mPlease install \"trash\" command.\033[m\n"
    read -lP "Use \"rm\" command [y/N]: " ans
    if test $ans = y; or test $ans = Y
      printf "\"rm\" command is enabled!\n"
      alias rm "command rm"
    end
  end
  alias rm "_stopUseRm"
end

if type -q nvim
  abbr --add v  "nvim"
else if type -q vim
  abbr --add v  "vim"
end

if type -q xsel
  alias pbcopy "xsel --clipboard --input"
  alias pbpaste "xsel --clipboard --output"
  abbr --add pbc "pbcopy"
  abbr --add pbp "pbpaste"
  alias pwdc 'pwd | tr -d "\n" | xsel --clipboard --input'
end

if type -q todo
  abbr --add t "todo"
  abbr --add ta   "todo add"
  abbr --add tad  "todo add"
  abbr --add td   "todo del"
  abbr --add trm  "todo del"
  abbr --add tmv  "todo move"
  abbr --add tt   "todo tag"
  abbr --add ttag "todo tag"
  abbr --add ts   "todo status"
  abbr --add tst  "todo status"
  abbr --add tl   "todo list"
  abbr --add tls  "todo list"
  abbr --add tcl  "todo clear"
end

if type -q codium && not type -q code
  alias code "codium"
end

if type -q calcurse
  abbr --add cl "calcurse"
end
