return {
  "nvimtools/none-ls.nvim",
  event = "VeryLazy",
  dependencies = {
  },
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.completion.tags,
        null_ls.builtins.completion.vsnip,

        null_ls.builtins.diagnostics.buf
      },
    }
    vim.keymap.set("n", "<LEADER>f", vim.lsp.buf.format, {})
  end,
}