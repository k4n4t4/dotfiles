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


let plug_exist = glob('~/.vim/autoload/plug.vim')

if empty(plug_exist)
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.vim/plugged')

Plug 'joshdick/onedark.vim'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'machakann/vim-highlightedyank'
Plug 'tpope/vim-surround'

call plug#end()

if ! empty(glob('~/.vim/plugged/onedark.vim'))
  colorscheme onedark
endif

