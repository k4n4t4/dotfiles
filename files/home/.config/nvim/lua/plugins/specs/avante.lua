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
        local mapping_prefix = "<leader>A"
        require("avante").setup {
            hints = {
                enabled = false,
            },
            behaviour = {
                auto_set_keymaps = true,
            },

            mappings = {
                ask = mapping_prefix .. "a",
                edit = mapping_prefix .. "e",
                new_ask = mapping_prefix .. "n",
                zen_mode = mapping_prefix .. "z",
                refresh = mapping_prefix .. "r",
                focus = mapping_prefix .. "f",
                stop = mapping_prefix .. "S",
                toggle = {
                    default = mapping_prefix .. "t",
                    debug = mapping_prefix .. "d",
                    selection = mapping_prefix .. "C",
                    suggestion = mapping_prefix .. "s",
                    repomap = mapping_prefix .. "R",
                },
                files = {
                    add_current = mapping_prefix .. "c",
                    add_all_buffers = mapping_prefix .. "B",
                },
                select_model = mapping_prefix .. "?",
                select_history = mapping_prefix .. "h",

                submit = {
                    normal = "<CR>",
                    insert = "<C-y>",
                },
                diff = {
                    ours = "co",
                    theirs = "ct",
                    all_theirs = "ca",
                    both = "cb",
                    cursor = "cc",
                    next = "]x",
                    prev = "[x",
                },
                suggestion = {
                    accept = "<M-l>",
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
                jump = {
                    next = "]]",
                    prev = "[[",
                },
                cancel = {
                    normal = { "<C-c>", "<Esc>", "q" },
                    insert = { "<C-c>" },
                },
                sidebar = {
                    expand_tool_use = "<S-Tab>",
                    next_prompt = "]p",
                    prev_prompt = "[p",
                    apply_all = "A",
                    apply_cursor = "a",
                    retry_user_request = "r",
                    edit_user_request = "e",
                    switch_windows = "<Tab>",
                    reverse_switch_windows = "<S-Tab>",
                    toggle_code_window = "x",
                    remove_file = "d",
                    add_file = "@",
                    close = { "q" },
                    close_from_input = {
                        normal = "q",
                        insert = "<C-d>",
                    },
                    toggle_code_window_from_input = {
                        normal = "x",
                        insert = "<C-;>",
                    },
                },
                confirm = {
                    focus_window = "<C-w>f",
                    code = "c",
                    resp = "r",
                    input = "i",
                },
            },

            provider = "copilot",
            providers = {
                copilot = {
                    model = "gpt-4.1",
                },
            },
        }
    end,
}
