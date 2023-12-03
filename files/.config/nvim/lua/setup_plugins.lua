vim.cmd.packadd "packer.nvim"

require("packer").startup(function()

  use { 'wbthomason/packer.nvim', opt = true}
  use 'navarasu/onedark.nvim'
  use 'khaveesh/vim-fish-syntax'
  use 'Shougo/unite.vim'
  use 'simeji/winresizer'
  use 'nathanaelkane/vim-indent-guides'
  use 'nvim-lualine/lualine.nvim'
  use 'xiyaowong/transparent.nvim'
  use 'lewis6991/gitsigns.nvim'
  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-tree/nvim-tree.lua'
  use 'nvim-tree/nvim-web-devicons'
  use 'romgrk/barbar.nvim'
  use 'dinhhuy258/git.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'rafamadriz/friendly-snippets'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-telescope/telescope.nvim'
  use 'pseewald/vim-anyfold'
  use 'tpope/vim-surround'
  use 'machakann/vim-highlightedyank'
  use 'mattn/emmet-vim'

end)

