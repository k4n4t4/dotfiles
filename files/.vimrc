set number
set expandtab
set autoindent
set tabstop=2
set shiftwidth=2
set hlsearch
set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:+
set list
set relativenumber
set completeopt=menuone,noinsert
" set cursorcolumn
set cursorline
set background=dark

if exists("syntax_on")
  syntax reset
endif
hi clear
hi Comment ctermfg=8
hi LineNr ctermfg=240
hi CursorLineNr ctermfg=252
hi MatchParen ctermbg=242

