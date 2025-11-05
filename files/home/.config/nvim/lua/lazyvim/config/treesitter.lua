return function()
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
end
