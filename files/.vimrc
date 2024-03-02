set number
set relativenumber
set numberwidth=1
set signcolumn=yes

set ruler

set mouse=a
set clipboard=unnamedplus

set encoding=utf-8

set showmode
set showcmd
set showmatch

set autoread
set hidden

set confirm

set expandtab
set autoindent
set tabstop=2
set shiftwidth=2

" search
set hlsearch
set incsearch

set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:+
set list

" set tabline=

set completeopt=menuone,noinsert

set cursorline
set cursorcolumn

set wildmenu
set wildmode=list:longest

" set virtualedit=onemore

set background=dark

" nnoremap k gk
" nnoremap j gj


if empty(glob("~/.vim/tmp"))
  silent !mkdir ~/.vim/tmp
endif

set directory=~/.vim/tmp
set backupdir=~/.vim/tmp
set undodir=~/.vim/tmp

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
Plug 'sheerun/vim-polyglot'
Plug 'pseewald/vim-anyfold'
call plug#end()

if ! empty(glob('~/.vim/plugged/onedark.vim'))
  if (has("autocmd") && ! has("gui_running"))
    augroup colorset
      autocmd!
      let s:white = {"gui": "#ABB2BF", "cterm": "145", "cterm16": "7"}
      autocmd ColorScheme * call onedark#set_highlight("Normal", {"fg": s:white })
    augroup END
    let g:onedark_color_overrides = {
      \ "background": {"gui": "#2F343F", "cterm": "235", "cterm16": "0"},
      \ "purple": {"gui": "#C678DF", "cterm": "170", "cterm16": "5"},
      \}
  endif
  colorscheme onedark
endif

if ! empty(glob('~/.vim/plugged/vim-anyfold'))
  autocmd Filetype * AnyFoldActivate
  set foldlevel=99
endif
