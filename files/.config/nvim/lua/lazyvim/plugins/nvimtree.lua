return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  event = "BufEnter",
  config = function()
    require("nvim-tree").setup {
      sort_by = "case_sensitive",
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = false,
        icons = {
          hint = "?",
          info = "i",
          warning = "*",
          error = "!",
        },
      },
    }
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.fn.isdirectory("%") == 1 then
          vim.cmd [[NvimTreeFocus]]
        end
      end
    })
  end,
  keys = {
    { mode = "n", "<leader>t", "<cmd>NvimTreeToggle<CR>", desc = "NvimTreeToggle" },
  }
}
