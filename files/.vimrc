set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8
set fileencodings=utf-8,sjis
set fileformats=unix,dos

set number
set relativenumber
set numberwidth=4

set cursorline
set cursorlineopt=number

set list
set listchars=tab:>-,extends:>,precedes:<,trail:-,nbsp:+,conceal:@
set fillchars=eob:\ 

set ambiwidth=single

set wrap
set display=lastline
set breakat=\ ^I!@*-+;:,./?
set linebreak
set breakindent
set showbreak=

set wildmenu
set wildignorecase
set wildmode=list:full

set scroll=10
set scrolloff=3

set showmode
set showcmd

set ruler

set belloff=all
set visualbell
set errorbells

set shortmess+=I

set smarttab
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smartindent
set autoindent

set hlsearch
set incsearch
set wrapscan
set ignorecase
set smartcase


if empty(glob("~/.local/state/vim/swap"))
  silent !mkdir -p ~/.local/state/vim/swap
endif
set swapfile
set directory=~/.local/state/vim/swap//

if empty(glob("~/.local/state/vim/backup"))
  silent !mkdir -p ~/.local/state/vim/backup
endif
set backup
set backupext=.bak
set backupdir=~/.local/state/vim/backup//
set writebackup

if empty(glob("~/.local/state/vim/undo"))
  silent !mkdir -p ~/.local/state/vim/undo
endif
set undofile
set undodir=~/.local/state/vim/undo//

set viminfo+=n~/.local/state/vim/.viminfo


set title
set mouse=a
set clipboard+=unnamedplus

set autoread

set hidden

set confirm

set splitbelow
set splitright

set virtualedit=block

set nogdefault

set whichwrap=b,s,h,l,~,<,>,[,]

set backspace=indent,eol,nostop

set nrformats=bin,octal,hex

set showmatch
set matchtime=1
set matchpairs=(:),{:},[:],<:>

set completeopt=menuone,preview

set notermguicolors
set background=dark

set ttimeoutlen=10


let mapleader = " "
nnoremap <SPACE> <NOP>

nnoremap <Char-127>
inoremap <Char-127>
vnoremap <Char-127>
cnoremap <Char-127>
onoremap <Char-127>

if has('vim_starting')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

syntax enable
if exists("syntax_on")
  syntax reset
endif
hi clear

hi LineNr ctermfg=240 ctermbg=234
hi CursorLineNr ctermfg=252 ctermbg=236
hi MatchParen ctermbg=242

hi Statement ctermfg=161
hi Type ctermfg=205
hi Special ctermfg=117

hi Comment ctermfg=8
hi String ctermfg=120
hi Number ctermfg=63
hi Function ctermfg=208


nnoremap <TAB> 5j
nnoremap <S-TAB> 5k
vnoremap <TAB> 5j
vnoremap <S-TAB> 5k
