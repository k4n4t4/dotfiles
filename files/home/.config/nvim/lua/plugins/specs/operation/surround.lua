return {
    "kylechui/nvim-surround";
    version = "^3.0.0";
    opts = {
        keymaps = {
            normal       = "ys";
            normal_cur   = "yss";
            normal_line  = "yS";
            visual       = "S";
            visual_line  = "S";
            delete       = "ds";
            change       = "cs";
        };
    };
    event = {
        'InsertEnter',
        'CmdlineEnter',
    };
}
