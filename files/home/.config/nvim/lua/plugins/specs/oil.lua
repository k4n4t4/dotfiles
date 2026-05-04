return {
    {
        "adelarsq/image_preview.nvim",
        event = "User Ready",
        config = function()
            require("image_preview").setup()
        end,
    },
    {
        'stevearc/oil.nvim',
        dependencies = {
            {
                "nvim-mini/mini.icons",
                opts = {},
            },
            "adelarsq/image_preview.nvim",
        },
        event = 'User DirEnter',
        config = function()
            require('oil').setup {
                show_hidden = true,
                keymaps = {
                    ["g."] = "actions.toggle_hidden",
                    ["<C-p>"] = "actions.preview",
                    ["gp"] = require("image_preview").PreviewImageOil,
                },
            }
        end,
        keys = {
            { mode = 'n', '<Leader>-', '<CMD>Oil<CR>',         desc = 'Oil' },
            { mode = 'n', '<Leader>=', '<CMD>Oil --float<CR>', desc = 'Oil float ' },
        },
    },
}
