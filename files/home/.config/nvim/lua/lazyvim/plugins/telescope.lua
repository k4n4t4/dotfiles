return {
    "nvim-telescope/telescope.nvim";
    dependencies = {
        "nvim-lua/plenary.nvim";
        "nvim-telescope/telescope-project.nvim";
        {
            "nvim-telescope/telescope-fzf-native.nvim";
            build = "make";
        };
        "stevearc/aerial.nvim";
    };
    config = require "lazyvim.config.telescope";
    cmd = "Telescope";
    keys = {
        { mode = 'n', "<LEADER>tt", "<CMD>Telescope<CR>",                           desc = "Telescope" },
        { mode = 'n', "<LEADER>tk", "<CMD>Telescope keymaps<CR>",                   desc = "Telescope Keymaps" },
        { mode = 'n', "<LEADER>tr", "<CMD>Telescope oldfiles<CR>",                   desc = "Telescope Oldfiles" },
        { mode = 'n', "<LEADER>tf", "<CMD>Telescope find_files<CR>",                desc = "Telescope Find Files" },
        { mode = 'n', "<LEADER>tg", "<CMD>Telescope live_grep<CR>",                 desc = "Telescope Live Grep" },
        { mode = 'n', "<LEADER>tb", "<CMD>Telescope buffers<CR>",                   desc = "Telescope Buffers" },
        { mode = 'n', "<LEADER>th", "<CMD>Telescope help_tags<CR>",                 desc = "Telescope Help Tags" },
        { mode = 'n', "<LEADER>t/", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Telescope Current Buffer Fuzzy Finder" },
        { mode = 'n', "<LEADER>tz", "<CMD>Telescope fzf<CR>",                       desc = "Telescope fzf" },
        { mode = 'n', "<LEADER>tp", "<CMD>Telescope project<CR>",                   desc = "Telescope Project" },
    };
}
