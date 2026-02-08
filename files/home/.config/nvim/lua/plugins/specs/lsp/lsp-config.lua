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
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {}
                    end
                }
            }

        end;
        event = {
            "BufReadPre",
            "BufNewFile",
        };
    },
}
