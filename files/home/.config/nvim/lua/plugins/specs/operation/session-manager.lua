return {
    "Shatur/neovim-session-manager",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local config = require('session_manager.config')
        require('session_manager').setup({
            autosave_last_session = true,
            autoload_mode = config.AutoloadMode.CurrentDir,
        })
    end,
    keys = {
        { "<leader>sd", "<cmd>SessionManager delete_session<cr>",       desc = "Delete Sessions" },
        { "<leader>sl", "<cmd>SessionManager load_session<cr>",         desc = "List Sessions" },
        { "<leader>ss", "<cmd>SessionManager save_current_session<cr>", desc = "Save Session" },
    },
    event = "VeryLazy",
}
