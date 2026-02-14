local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

local lsp = require "utils.lsp"

lsp.set("core.lsp.config", {
    { {"c", "cpp"}, "clangd" },
    { {"html", "css"}, "emmet_language_server" },
    { {"lua"}, "lua_ls" },
    { {"sh", "bash"}, "bashls" },
})
lsp.auto_set()
