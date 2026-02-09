return {
    {
        "nvim-treesitter/nvim-treesitter";
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects";
        };
        build = ":TSUpdate";
        config = function()
            require("nvim-treesitter.config").setup {
                ignore_install = {};
                modules = {};

                sync_install = true;
                auto_install = true;
                ensure_installed = {
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                };
                highlight = {
                    enable = true;
                };
                indent = {
                    enable = true;
                };
                fold = {
                    enable = true;
                };
                incremental_selection = {
                    enable = true;
                    keymaps = {
                        init_selection = "<CR>";
                        node_incremental = "<CR>";
                        scope_incremental = false;
                        node_decremental = "<BS>";
                    };
                };
                textobjects = {
                    select = {
                        enable = true;
                        lookahead = true;
                        keymaps = {
                            ["af"] = "@function.outer";
                            ["if"] = "@function.inner";
                            ["ac"] = "@class.outer";
                            ["ic"] = "@class.inner";
                            ["ab"] = "@block.outer";
                            ["ib"] = "@block.inner";
                            ["aa"] = "@parameter.outer";
                            ["ia"] = "@parameter.inner";
                        };
                    };
                };
            }
        end;
        event = 'VeryLazy';
        cmd = {
            "TSUpdate",
            "TSInstall",
            "TSUninstall",
            "TSToggle",
            "TSEnable",
            "TSDisable",
            "TSBufToggle",
            "TSBufEnable",
            "TSBufDisable",
        };
    },
    {
        "nvim-treesitter/nvim-treesitter-context";
        event = 'VeryLazy';
        dependencies = {
            "nvim-treesitter/nvim-treesitter";
        };
    },
}
