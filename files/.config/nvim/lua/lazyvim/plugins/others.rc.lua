return {

  -- colorschemes
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = {
      style = "darker",
    },
  },
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
  },
  {
    "folke/tokyonight.nvim",
    lazy = true,
  },
  {
    "sainnhe/everforest",
    lazy = true,
    config = function()
      vim.g.everforest_background = 'soft'
    end
  },
  {
    "sainnhe/gruvbox-material",
    lazy = true,
    config = function()
      vim.g.gruvbox_material_background = 'medium'
    end
  },

  -- highlights
  {
    "fladson/vim-kitty",
    ft = "kitty",
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    ft = "markdown",
    name = "render-markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },


  {
    "mattn/emmet-vim",
    event = 'VeryLazy',
  },

  {
    "windwp/nvim-autopairs",
    opts = {
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      disable_in_macro = true,
      disable_in_visualblock = false,
      disable_in_replace_mode = true,
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      enable_moveright = true,
      enable_afterquote = true,
      enable_check_bracket_line = true,
      enable_bracket_in_quote = true,
      enable_abbr = false,
      break_undo = true,
      check_ts = false,
    },
    event = "InsertEnter",
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = 'VeryLazy',
  },


  {
    "dstein64/vim-startuptime",
    cmd = 'StartupTime',
  },

  {
    "folke/which-key.nvim",
    opts = {
      preset = 'modern',
      delay = function(ctx)
        return ctx.plugin and 0 or 500
      end,
      win = {
        border = 'single',
      },
    },
    event = 'VeryLazy',
    keys = {
      {
        mode = 'n',
        '<LEADER>?',
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Which Key"
      },
    }
  },

  {
    "phaazon/hop.nvim",
    branch = "v2",
    opts = {
      multi_windows = true,
    },
    keys = {
      { mode = 'n', '<LEADER>jj', "<CMD>HopWord<CR>",     desc = "Hop Word" },
      { mode = 'n', '<LEADER>ja', "<CMD>HopAnywhere<CR>", desc = "Hop Anywhere" },
      { mode = 'n', '<LEADER>jl', "<CMD>HopLine<CR>",     desc = "Hop Line" },
      { mode = 'n', '<LEADER>jv', "<CMD>HopVertical<CR>", desc = "Hop Vertical" },
      { mode = 'n', '<LEADER>jc', "<CMD>HopChar1<CR>",    desc = "Hop Char1" },
      { mode = 'n', '<LEADER>j2', "<CMD>HopChar2<CR>",    desc = "Hop Char2" },
      { mode = 'n', '<LEADER>jp', "<CMD>HopPattern<CR>",  desc = "Hop Pattern" },
    }
  },

  {
    "kylechui/nvim-surround",
    event = 'VeryLazy',
    config = function()
      require("nvim-surround").setup {}
    end
  },

  {
    "mattn/emmet-vim",
    event = 'VeryLazy',
  },

  {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
      {
        "<LEADER>xx",
        "<CMD>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<LEADER>xX",
        "<CMD>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<LEADER>xs",
        "<CMD>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<LEADER>xl",
        "<CMD>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<LEADER>xL",
        "<CMD>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<LEADER>xQ",
        "<CMD>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
    event = 'VeryLazy',
  },
}
