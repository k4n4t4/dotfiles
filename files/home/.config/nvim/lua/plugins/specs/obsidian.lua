return {
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
}
