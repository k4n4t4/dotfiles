-- local lsp = require "utils.lsp"

-- lsp.set("core.lsp.config", {
--     { {"c", "cpp"}, "clangd" },
--     { {"html", "css"}, "emmet_language_server" },
--     { {"lua"}, "lua_ls" },
--     { {"sh", "bash"}, "bash_ls" },
-- })


local lua_ls_config = require("core.lsp.config.lua_ls")
vim.lsp.config("lua_ls", lua_ls_config)
vim.lsp.enable("lua_ls")
