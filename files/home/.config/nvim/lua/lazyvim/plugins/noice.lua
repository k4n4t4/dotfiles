return {
  "folke/noice.nvim";
  enabled = true;
  dependencies = {
    "MunifTanjim/nui.nvim";
    "rcarriga/nvim-notify";
  };
  config = require "lazyvim.config.noice";
  event = 'VeryLazy';
}
