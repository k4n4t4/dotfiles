return {
  'nvimdev/lspsaga.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
  },
  event = 'VeryLazy',
  keys = {
    { mode = 'n', '<LEADER>go', "<CMD>Lspsaga outline<CR>", desc = "Lspsaga Outline" },
    { mode = 'n', '<LEADER>gf', "<CMD>Lspsaga finder<CR>", desc = "Lspsaga Finder" },
  },
}
