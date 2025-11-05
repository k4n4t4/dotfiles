return {
  {
    "nvim-treesitter/nvim-treesitter";
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects";
    };
    build = ":TSUpdate";
    config = require "lazyvim.config.treesitter";
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
