return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            }
          }
        }
      })

      pcall(require("telescope").load_extension, "fzf")

      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      end
      map("n", "<leader>fr", require("telescope.builtin").oldfiles, "Recently opened")
      map("n", "<leader><space>", require("telescope.builtin").buffers, "Open buffers")
      map("n", "<leader>/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false
        }))
      end, "Search in current buffer")

      map("n", "<leader>sf", require("telescope.builtin").find_files, "Files")
      map("n", "<leader>sh", require("telescope.builtin").help_tags, "Help")
      map("n", "<leader>sw", require("telescope.builtin").grep_string, "Current word")
      map("n", "<leader>sg", require("telescope.builtin").live_grep, "Grep")
      map("n", "<leader>sd", require("telescope.builtin").diagnostics, "Diagnostics")

      map("n", "<C-p>", require("telescope.builtin").keymaps, "Search keymaps")
    end
  }
}
