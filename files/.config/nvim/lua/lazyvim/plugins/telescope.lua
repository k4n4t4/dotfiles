return {
  'nvim-telescope/telescope.nvim',
  event = "VeryLazy",
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    defaults = {
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    },
  },
  keys = {
    { mode = "n", "<LEADER>t", "<cmd>Telescope<CR>", desc = "Telescope" },
    { mode = "n", "<LEADER>tt", "<cmd>Telescope<CR>", desc = "Telescope" },
    { mode = "n", "<LEADER>tk", "<cmd>Telescope keymaps<CR>", desc = "Telescope Keymaps" },
    { mode = "n", "<LEADER>tf", "<cmd>Telescope find_files<CR>", desc = "Telescope Find Files" },
    { mode = "n", "<LEADER>tg", "<cmd>Telescope live_grep<CR>", desc = "Telescope Live Grep" },
    { mode = "n", "<LEADER>tb", "<cmd>Telescope buffers<CR>", desc = "Telescope Buffers" },
    { mode = "n", "<LEADER>th", "<cmd>Telescope help_tags<CR>", desc = "Telescope Help Tags" },
  },
}
