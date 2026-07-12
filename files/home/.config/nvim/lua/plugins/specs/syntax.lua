return {
    --[[ TREESITTER ]]--
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },

    --[[ MARKDOWN PLUGINS ]]--
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require('render-markdown').setup {
                completions = {
                    lsp = {
                        enabled = true,
                    },
                },
                latex = {
                    enabled = false,
                },
                file_types = { "markdown", "Avante" },
            }
        end,
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
