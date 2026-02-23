return {
    "nvimtools/none-ls.nvim",
    event = {
        'InsertEnter',
        'CmdlineEnter',
    },
    config = function()
        local null_ls = require "null-ls"
        null_ls.setup {
            sources = {
                null_ls.builtins.diagnostics.buf,
            },
        }
    end,
}
