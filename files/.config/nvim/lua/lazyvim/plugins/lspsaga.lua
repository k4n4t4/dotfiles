return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',     -- optional
    'nvim-tree/nvim-web-devicons',         -- optional
  },
  event = 'VeryLazy',
  config = function()
    require('lspsaga').setup {}
  end,
}
