return {
    {
        "nvim-treesitter/nvim-treesitter";
        build = ":TSUpdate";
        config = function()
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    pcall(vim.treesitter.start)
                end;
            })
            vim.api.nvim_create_autocmd('FileType', {
                callback = function()
                    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    vim.wo[0][0].foldmethod = 'expr'
                    vim.opt.foldlevel = 99
                    vim.opt.foldlevelstart = 99
                end;
            })
        end;
        lazy = false
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects";
        branch = "main";
        init = function()
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup {
                select = {
                    lookahead = true;
                };
            }

            local map = vim.keymap.set

            map({ "x", "o" }, "af", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
            end)
            map({ "x", "o" }, "if", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
            end)
            map({ "x", "o" }, "ac", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
            end)
            map({ "x", "o" }, "ic", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
            end)
            map({ "x", "o" }, "ab", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@block.outer", "textobjects")
            end)
            map({ "x", "o" }, "ib", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@block.inner", "textobjects")
            end)
            map({ "x", "o" }, "aa", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
            end)
            map({ "x", "o" }, "ia", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
            end)
        end;
        lazy = false;
    },
    {
        "nvim-treesitter/nvim-treesitter-context";
        event = 'VeryLazy';
        dependencies = {
            "nvim-treesitter/nvim-treesitter";
        };
    },
}
