return {
  {
    "nvim-treesitter/nvim-treesitter";
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects";
    };
    build = ":TSUpdate";
    config = function()
      require("nvim-treesitter.configs").setup {
        sync_install = true;
        auto_install = true;
        ignore_install = {};
        modules = {};
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
        };
        highlight = {
          enable = true;
          disable = {};
        };
        indent = {
          enable = true;
        };
      }
    end;
    event = 'VeryLazy';
    cmd = {
      "TSUpdate",
      "TSInstall",
      "TSUninstall",
      "TSToggle",
      "TSEnable",
      "TSDisable",
      "TSBufToggle",
      "TSBufEnable",
      "TSBufDisable",
    };
  },
  {
    "nvim-treesitter/nvim-treesitter-context";
    event = 'VeryLazy';
    dependencies = {
      "nvim-treesitter/nvim-treesitter";
    };
  },
}
