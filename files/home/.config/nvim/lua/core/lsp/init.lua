local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local win_opts = { border = "shadow", winblend = 10 }
vim.lsp.config("*", {
    handlers = {
        ["textDocument/hover"] = function(err, result, ctx, config)
            vim.lsp.handlers["textDocument/hover"](
                err, result, ctx, vim.tbl_extend("force", config or {}, win_opts)
            )
        end,
        ["textDocument/signatureHelp"] = function(err, result, ctx, config)
            vim.lsp.handlers["textDocument/signatureHelp"](
                err, result, ctx, vim.tbl_extend("force", config or {}, win_opts)
            )
        end,
    },
})

local lsp = require "utils.lsp"

lsp.auto_set("core.lsp.config")
