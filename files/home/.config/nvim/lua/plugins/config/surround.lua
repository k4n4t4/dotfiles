return function()
    require("nvim-surround").setup {
        keymaps = {
            normal       = "ys";
            normal_cur   = "yss";
            normal_line  = "yS";
            visual       = "S";
            visual_line  = "S";
            delete       = "ds";
            change       = "cs";
        };
    }
end
