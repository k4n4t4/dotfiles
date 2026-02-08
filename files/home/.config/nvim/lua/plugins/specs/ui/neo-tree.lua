return {
    "nvim-neo-tree/neo-tree.nvim";
    branch = "v3.x";
    dependencies = {
        "nvim-lua/plenary.nvim";
        "nvim-tree/nvim-web-devicons";
        "MunifTanjim/nui.nvim";
        "3rd/image.nvim";
        {
            's1n7ax/nvim-window-picker';
            version = '2.*';
            config = function()
                require("window-picker").setup {
                    filter_rules = {
                        include_current_win = false;
                        autoselect_one = true;
                        bo = {
                            filetype = { "neo-tree", "neo-tree-popup", "notify" };
                            buftype = { 'terminal', 'quickfix' };
                        };
                    };
                }
            end;
        };
    };
    config = require "plugins.config.neo-tree";
    event = 'User DirEnter';
    keys = {
        { mode = 'n', "<LEADER>e", "<CMD>Neotree toggle<CR>", desc = "Neotree Toggle" },
        { mode = 'n', "<LEADER>E", "<CMD>Neotree focus<CR>", desc = "Neotree Focus" },
    };
}
