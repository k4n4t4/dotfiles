function multicd
  set -l length (math (string length -- $argv) - 1)
  echo cd (string repeat -n $length ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

abbr --add pd "prevd"
abbr --add nd "nextd"

abbr --add cmd "command"
abbr --add hist "history"
abbr --add c "clear"
abbr --add q "exit"


alias cp "cp -iv"
alias mv "mv -iv"


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
  abbr --add tmclear "clear && tmux clear-history"
  abbr --add tmrm    "tmux kill-session"
  abbr --add tmrmt   "tmux kill-session -t"
  abbr --add tmkill  "tmux kill-server"
end

if type -q git
  alias groot "cd:gitroot"

  abbr --add g      "git"
  abbr --add ga     "git add"
  abbr --add gd     "git diff"
  abbr --add gdc    "git diff --cached"
  abbr --add gs     "git status"
  abbr --add gst    "git status"
  abbr --add gss    "git status -s"
  abbr --add gp     "git push"
  abbr --add gpl    "git pull"
  abbr --add gb     "git branch"
  abbr --add gbd    "git branch -d"
  abbr --add gbfd   "git branch -D"
  abbr --add gm     "git merge"
  abbr --add gco    "git checkout"
  abbr --add gcob   "git checkout -b"
  abbr --add gf     "git fetch"
  abbr --add gc     "git commit"
  abbr --add gcm    "git commit -m"
  abbr --add gcmu   "git commit -m update"
  abbr --add gcmau  "git add . && git commit -m update"
  abbr --add gcmaup "git add . && git commit -m update && git push"
  abbr --add gu     "git add . && git commit -m update && git push"
  abbr --add gr     "git remote"
  abbr --add gbl    "git blame"
  abbr --add gl     "git log"
  abbr --add glp    "git log -p"
  abbr --add gld    "git log -p --full-diff"
end

if type -q eza
  alias eza    "eza --icons --git -H --sort=type --time-style=long-iso"
  alias ls     "eza"
  alias ll     "eza -F -l"
  alias llT    "eza -F -l --sort time"
  alias la     "eza -F -a"
  alias lla    "eza -F -la"
  alias llaT   "eza -F -la --sort time"
  alias l      "eza -F"
  alias lt     "eza -F -T"
  alias lta    "eza -F -Ta"
  alias llt    "eza -F -Tl"
  alias llta   "eza -F -Tla"
  alias lltT   "eza -F -Tl --sort time"
  alias lltaT  "eza -F -Tla --sort time"
  alias lll    "eza -F -l -igbhHSOM@ --git-repos"
  alias llla   "eza -F -la -igbhHSOM@ --git-repos"
  alias lllt   "eza -F -Tl -igbhHSOM@ --git-repos"
  alias lllta  "eza -F -Tla -igbhHSOM@ --git-repos"
  alias lllT   "eza -F -l -igbhHSOM@ --git-repos --sort time"
  alias lllaT  "eza -F -la -igbhHSOM@ --git-repos --sort time"
  alias llltT  "eza -F -Tl -igbhHSOM@ --git-repos --sort time"
  alias llltaT "eza -F -Tla -igbhHSOM@ --git-repos --sort time"
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

if type -q trash
  alias rm "trash"
end

if type -q nvim
  function _nvim
    if test "$NVIM" = ""
      command nvim $argv
    else
      for file in $argv
        command nvim --server $NVIM --remote-tab (realpath $file)
      end
    end
  end
  alias nvim "_nvim"
  abbr --add v  "nvim"
else if type -q vim
  abbr --add v  "vim"
end

if type -q xsel
  alias pbcopy "xsel --clipboard --input"
  alias pbpaste "xsel --clipboard --output"

  alias pwdcopy 'pwd | tr -d "\n" | pbcopy'
end

if type -q codium && not type -q code
  alias code "codium"
end

if type -q calcurse
  abbr --add cl "calcurse"
end

if type -q yay
  alias yay "yay --color auto"
end

if type -q todo
  abbr --add t  "todo"
  abbr --add ta "todo add"
  abbr --add td "todo del"
  abbr --add tm "todo move"
  abbr --add tt "todo tag"
  abbr --add ts "todo status"
  abbr --add tl "todo list"
  abbr --add tc "todo clear"
end
