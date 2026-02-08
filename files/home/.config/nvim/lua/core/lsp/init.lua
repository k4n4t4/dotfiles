local lsp = require "utils.lsp"

lsp.set("core.lsp.config", {
    { {"c", "cpp"}, "clangd" },
    { {"html", "css"}, "emmet_language_server" },
    { {"lua"}, "lua_ls" },
    { {"sh", "bash"}, "bash_ls" },
})
