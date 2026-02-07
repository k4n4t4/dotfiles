return function()
    local mason_lspconfig = require("mason-lspconfig")

    local lsps = {
        "lua_ls",
        "emmet_language_server",
        "clangd",
    }
    for _, value in ipairs(lsps) do
        vim.lsp.config(value, require("plugins.config.lsp." .. value))
        vim.lsp.enable(value)
    end

    mason_lspconfig.setup {
        ensure_installed = {
            "vimls",
            "pylsp",
            "bashls",
            "ts_ls",
        };
        automatic_enable = true;
    }
end
