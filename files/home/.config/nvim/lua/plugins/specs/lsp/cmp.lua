return {
    {
        "hrsh7th/nvim-cmp";
        dependencies = {
            "hrsh7th/cmp-nvim-lsp";
            "hrsh7th/cmp-emoji";
            "hrsh7th/cmp-buffer";
            "hrsh7th/cmp-path";
            "hrsh7th/cmp-git";
            "hrsh7th/cmp-cmdline";
            "hrsh7th/cmp-calc";
            "yutkat/cmp-mocword";
            "onsails/lspkind.nvim";
            "nvimtreesitter/nvim-treesitter";
            "ray-x/cmp-treesitter";
            "zbirenbaum/copilot-cmp";
            "saadparwaiz1/cmp_luasnip";
            {
                "L3MON4D3/LuaSnip";
                build = "make install_jsregexp";
            };
            "rafamadriz/friendly-snippets";
        };
        config = require "plugins.config.cmp";
        event = {
            'InsertEnter',
            'CmdlineEnter',
        };
        cmd = "CmpStatus";
    }
}
