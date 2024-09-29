vim.g.terminal_color_13 = "#00ff00"

return {
  "lambdalisue/vim-fern",
  dependencies = {
    "lambdalisue/nerdfont.vim",
    "lambdalisue/fern-renderer-nerdfont.vim",
    "lambdalisue/glyph-palette.vim",
    "lambdalisue/fern-git-status.vim",
  },
  event = "BufEnter",
  config = function()
    vim.g["fern#renderer"] = "nerdfont"

    vim.api.nvim_create_autocmd({
      "FileType"
    }, {
      pattern = "fern",
      callback = function()
        vim.fn["glyph_palette#apply"]()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.foldcolumn = '0'
        vim.opt_local.signcolumn = "no"
        vim.keymap.set("n", "<CR>", "<PLUG>(fern-action-open-or-expand)", {buffer = true})
        vim.keymap.set("n", "<S-CR>", "<PLUG>(fern-action-collapse)", {buffer = true})
      end
    })

    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.fn.isdirectory("%") == 1 then
          vim.cmd.Fern(".", "-reveal=%")
        end
      end
    })
  end,
  keys = {
    { mode = "n", "<LEADER>e", "<CMD>Fern . -reveal=% -drawer -toggle -width=25<CR>", desc = "Fern Drawer" },
    {
      desc = "Fern Drawer",
      mode = "n", "<LEADER>Eo",
      function()
        if vim.bo.filetype == "fern" then
          vim.cmd.wincmd "p"
        else
          vim.cmd.Fern(".", "-reveal=%", "-drawer", "-width=25")
        end
      end,
    },
  }
}
