return function()
    require("nvim-treesitter.configs").setup {
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

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false;
end
