return {
    "folke/noice.nvim";
    enabled = true;
    dependencies = {
        "MunifTanjim/nui.nvim";
        "rcarriga/nvim-notify";
    };
    config = require "plugins.config.noice";
    event = 'VeryLazy';
}
