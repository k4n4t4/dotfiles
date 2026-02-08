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
        config = require "plugins.config.lsp-config";
        event = { "BufReadPre", "BufNewFile" };
    },

    {
        "mrcjkb/rustaceanvim";
        ft = "rust";
        event = 'VeryLazy';
        version = '^5';
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    enable_clippy = true;
                };
                server = {
                    default_settings = {
                        ['rust-analyzer'] = {
                            assist = {
                                importGranularity = "module";
                                importEnforceGranularity = true;
                                importPrefix = 'crate';
                            };
                            useLibraryCodeForTypes = true;
                            autoSearchPaths = true;
                            autoImportCompletions = true;
                            reportMissingImports = true;
                            followImportForHints = true;
                            cargo = {
                                allFeatures = true;
                            };
                            check = {
                                command = "clippy";
                            };
                            checkOnSave = {
                                command = "clippy"
                            };
                            inlayHints = { locationLinks = false };
                            diagnostics = {
                                enable = true;
                                experimental = {
                                    enable = true;
                                };
                            };
                        };
                    };
                }
            }
        end;
    },
}
