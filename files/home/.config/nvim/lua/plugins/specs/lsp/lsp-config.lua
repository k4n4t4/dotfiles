return {
    {
        "mason-org/mason-lspconfig.nvim";
        dependencies = {
            {
                "mason-org/mason.nvim";
                opts = {
                    ui = {
                        border = 'double';
                    };
                };
            },
            "neovim/nvim-lspconfig";
            "nvimtools/none-ls.nvim";
            "jayp0521/mason-null-ls.nvim";
        };
        config = function()
            local mason_lspconfig = require("mason-lspconfig")

            mason_lspconfig.setup {
                ensure_installed = {
                    "vimls",
                };
                automatic_enable = false;
            }


            local lsps = {
                "lua_ls",
                "emmet_language_server",
                "clangd",
            }
            for _, value in ipairs(lsps) do
                vim.lsp.config(value, require("plugins.specs.lsp.config." .. value))
                vim.lsp.enable(value)
            end
        end;
        event = { "BufReadPre", "BufNewFile" };
    },
}
