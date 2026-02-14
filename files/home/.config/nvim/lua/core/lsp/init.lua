local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local lsp = require "utils.lsp"

lsp.auto_set("core.lsp.config")
