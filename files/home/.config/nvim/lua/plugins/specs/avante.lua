return {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = "VeryLazy",
    version = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",

        "nvim-telescope/telescope.nvim",
        "ibhagwan/fzf-lua",
        "nvim-mini/mini.pick",
        "hrsh7th/nvim-cmp",

        "zbirenbaum/copilot.lua",
        {
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    use_absolute_path = true,
                },
            },
        },
        {
            'MeanderingProgrammer/render-markdown.nvim',
            opts = {
                file_types = { "markdown", "Avante" },
            },
            ft = { "markdown", "Avante" },
        },
    },
    config = function()
        require("avante").setup {
            provider = "copilot",
            providers = {
                copilot = {
                    model = "gpt-4o",
                },
            },
        }
    end,
    keys = {
        {
            "<leader>At",
            function() require("avante").toggle() end,
            desc = "Toggle Avante",
        },
    },
}
