return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    return {
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    }
  end,
  keys = {
    { mode = "n", "<leader>t", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeToggle" },
  }
}
