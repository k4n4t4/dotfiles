return {
    "kylechui/nvim-surround";
    version = "^3.0.0";
    config = require "plugins.config.surround";
    event = {
        'InsertEnter',
        'CmdlineEnter',
    };
}
