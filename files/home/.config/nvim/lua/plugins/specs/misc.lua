return {
    { "nvim-tree/nvim-web-devicons" },

    {
        "folke/flash.nvim",
        keys = {
            { mode = "n",               "f" },
            { mode = "n",               "F" },
            { mode = "n",               "t" },
            { mode = "n",               "T" },
            { mode = { "n", "x", "o" }, "<Leader>ff", function() require("flash").jump() end,              desc = "Flash" },
            { mode = { "n", "x", "o" }, "<Leader>ft", function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { mode = "o",               "<Leader>fr", function() require("flash").remote() end,            desc = "Remote Flash" },
            { mode = { "o", "x" },      "<Leader>fR", function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { mode = { "c" },           "<C-s>",      function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
        opts = {},
    },

    {
        "shellRaining/hlchunk.nvim",
        event = 'User Ready',
        config = function()
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                    style = {
                        { fg = "#303030" },
                        { fg = "#903020" },
                    },
                    use_treesitter = true,
                    chars = {
                        horizontal_line = "─",
                        vertical_line = "│",
                        left_top = "┌",
                        left_bottom = "└",
                        right_arrow = ">",
                    },
                    textobject = "",
                    max_file_size = 1024 * 1024,
                    error_sign = true,
                    delay = 0,
                },
                indent = {
                    enable = false,
                },
            }
        end,
    },

    {
        'Bekaboo/dropbar.nvim',
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        event = 'User Ready',
        config = function()
            local dropbar_api = require('dropbar.api')
            vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
            vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
            vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
        end
    },

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            {
                "<LEADER>xx",
                "<CMD>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<LEADER>xX",
                "<CMD>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<LEADER>xs",
                "<CMD>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<LEADER>xl",
                "<CMD>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<LEADER>xL",
                "<CMD>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<LEADER>xQ",
                "<CMD>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        opts = {},
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        ft = { "markdown" },
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim", },
        config = function()
            local function setup_obsidian()
                local cwd = vim.fn.getcwd()
                local vault = vim.fn.isdirectory(cwd .. "/.obsidian") == 1 and cwd or nil
                if vault then
                    require("obsidian").setup {
                        workspaces = {
                            {
                                name = "main",
                                path = vault,
                            },
                        },
                        preferred_link_style = "wiki",
                        ui = { enable = false, },
                        completion = {
                            blink = true,
                            min_chars = 2,
                        },
                    }
                end
            end

            setup_obsidian()

            vim.api.nvim_create_autocmd("DirChanged", {
                pattern = "*",
                callback = setup_obsidian,
            })
        end,
    },
}
