return {
  "folke/noice.nvim";
  dependencies = {
    "MunifTanjim/nui.nvim";
    "rcarriga/nvim-notify";
  };
  config = function()
    require("noice").setup {
      cmdline = {
        enabled = true;
        view = 'cmdline';
        format = {
          cmdline = { pattern = "^:", icon = "", lang = "vim" };
          search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" };
          search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" };
          filter = { pattern = "^:%s*!", icon = "$", lang = "bash" };
          lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" };
          help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋗" };
          input = { view = "cmdline_input", icon = "󰥻" };
        };
      };
      messages = {
        enabled = true;
        view = 'mini';
        view_warn = 'notify';
        view_error = 'notify';
        view_history = 'messages';
        view_search = 'virtualtext';
      };
      popupmenu = {
        enabled = true;
        backend = "nui";
      };
      redirect = {
        view = 'popup';
      };
      commands = {
        history = {
          view = 'split';
        };
        last = {
          view = 'popup';
        };
        errors = {
          view = 'popup';
        };
        all = {
          view = 'split';
        };
      };
      notify = {
        enabled = true;
        view = 'notify';
      };
      lsp = {
        progress = {
          enabled = true;
          format_done = "lsp_progress_done";
          throttle = 1000 / 30;
          view = 'mini';
        };
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true;
          ["vim.lsp.util.stylize_markdown"] = true;
          ["cmp.entry.get_documentation"] = true;
        };
        hover = {
          enabled = true;
          silent = false;
          view = nil;
          opts = {};
        };
        signature = {
          enabled = true;
          auto_open = {
            enabled = true;
            trigger = true;
            luasnip = true;
            throttle = 50;
          };
          view = nil;
        };
        message = {
          enabled = true;
          view = 'notify';
        };
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        inc_rename = true;
        lsp_doc_border = true;
      };
      throttle = 1000 / 30;
    }
    require("notify").setup {
      render = "wrapped-compact";
      stages = "slide";
      timeout = 2000;
      top_down = true;
    }
  end;
  event = 'VeryLazy';
}
