return {
  "nvimtools/none-ls.nvim",
  enabled = true,

  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.diagnostics.buf,
      },
    }
  end,

  event = {
    'InsertEnter',
    'CmdlineEnter',
  },
}
