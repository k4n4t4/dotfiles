return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    sort_by = "case_sensitive",
    renderer = {
      group_empty = true,
    },
    filters = {
      dotfiles = true,
    },
  },
  keys = {
    {
      mode = "n", "<leader>t", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeToggle"
    },
  }
}
