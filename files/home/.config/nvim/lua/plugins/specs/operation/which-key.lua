return {
    "folke/which-key.nvim";
    config = require "plugins.config.which-key";
    event = 'VeryLazy';
    keys = {
        {
            mode = "n",
            '<LEADER>?',
            function()
                require("which-key").show({ global = true })
            end,
            desc = "Which Key"
        },
    };
}
