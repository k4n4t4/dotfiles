return {
  "nvimtools/none-ls.nvim",
  event = 'VeryLazy',
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.completion.spell,
        null_ls.builtins.completion.tags,

        null_ls.builtins.diagnostics.buf
      },
    }
  end,
}
