local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.lsp.enable {
    "html",
    "emmet_language_server",
    "omnisharp",
    "jdtls",
    "ts_ls",
    "powershell_es",
    "lua_ls",
    "bashls",
}
