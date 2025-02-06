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
  {
    "EdenEast/nightfox.nvim",
    lazy = true,
    opts = {
      options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        },
      },
    },
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
    "leafgarland/typescript-vim",
    ft = {"typescript", "typescriptreact", "*.tsx", "*.jsx"},
  },
  {
    "peitalin/vim-jsx-typescript",
    ft = {"typescript", "typescriptreact", "*.tsx", "*.jsx"},
  },
  {
    "folke/lsp-colors.nvim",
    event = 'VeryLazy',
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = 'VeryLazy',
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = 'VeryLazy',
  },
  {
    "m-demare/hlargs.nvim",
    event = 'VeryLazy',
  },
  {
    "unblevable/quick-scope",
    event = 'VeryLazy',
    enabled = false,
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
    event = 'VeryLazy',
    config = function()
      local illuminate = require("illuminate")
      illuminate.configure {
        providers = {
          'lsp',
          'treesitter',
          'regex',
        },
        delay = 500,
        filetype_overrides = {},
        filetypes_denylist = {
          'dirbuf',
          'dirvish',
          'fugitive',
        },
        filetypes_allowlist = {},
        modes_denylist = {},
        modes_allowlist = {},
        providers_regex_syntax_denylist = {},
        providers_regex_syntax_allowlist = {},
        under_cursor = true,
        large_file_cutoff = nil,
        large_file_overrides = nil,
        min_count_to_highlight = 1,
        should_enable = function(bufnr) return true end,
        case_insensitive_regex = false,
      }
    end,
  },
  {
    "andersevenrud/nvim_context_vt",
    enabled = false,
    event = 'VeryLazy',
    opts = {
      enabled = true,
      prefix = '',
      highlight = 'ContextVt',
      disable_ft = { 'markdown' },
      disable_virtual_lines = false,
      disable_virtual_lines_ft = {},
      min_rows = 1,
      min_rows_ft = {},
    },
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = 'VeryLazy',
    config = function()
      local todo_comments = require("todo-comments")
      todo_comments.setup {
        signs = true,
        sign_priority = 8,
        keywords = {
          FIX = {
            icon = " ",
            color = "error",
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
          TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
        },
        gui_style = {
          fg = "NONE",
          bg = "BOLD",
        },
        merge_keywords = true,
        highlight = {
          multiline = true,
          multiline_pattern = "^.",
          multiline_context = 10,
          before = "",
          keyword = "wide",
          after = "fg",
          pattern = [[.*<(KEYWORDS)\s*:]],
          comments_only = true,
          max_line_len = 400,
          exclude = {},
        },
        colors = {
          error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
          warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
          info = { "DiagnosticInfo", "#2563EB" },
          hint = { "DiagnosticHint", "#10B981" },
          default = { "Identifier", "#7C3AED" },
          test = { "Identifier", "#FF00FF" }
        },
        search = {
          command = "rg",
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
          },
          pattern = [[\b(KEYWORDS):]],
        },
      }

      vim.keymap.set("n", "]t", function()
        todo_comments.jump_next()
      end, { desc = "Next todo comment" })
      vim.keymap.set("n", "[t", function()
        todo_comments.jump_prev()
      end, { desc = "Previous todo comment" })
      vim.keymap.set("n", "]t", function()
        todo_comments.jump_next({keywords = { "ERROR", "WARNING" }})
      end, { desc = "Next error/warning todo comment" })
    end
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
    "monaqa/dial.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      local dial = require "dial.config"
      local augend = require "dial.augend"

      dial.augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.integer.alias.octal,
          augend.integer.alias.binary,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%m/%d/%Y"],
          augend.date.alias["%d/%m/%Y"],
          augend.date.alias["%m/%d/%y"],
          augend.date.alias["%d/%m/%y"],
          augend.date.alias["%m/%d"],
          augend.date.alias["%-m/%-d"],
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y年%-m月%-d日"],
          augend.date.alias["%Y年%-m月%-d日(%ja)"],
          augend.date.alias["%H:%M:%S"],
          augend.date.alias["%H:%M"],
          augend.constant.alias.ja_weekday,
          augend.constant.alias.ja_weekday_full,
          augend.constant.alias.bool,
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
          augend.semver.alias.semver,
          -- augend.paren.alias.quote,
          -- augend.paren.alias.brackets,
          augend.paren.alias.lua_str_literal,
          augend.paren.alias.rust_str_literal,
          augend.misc.alias.markdown_header,
        },
      }
    end,
    keys = {
      { mode = 'n', "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "Increment" },
      { mode = 'n', "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "Decrement" },
      { mode = 'n', "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "gIncrement" },
      { mode = 'n', "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "gDecrement" },
      { mode = 'v', "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  desc = "vIncrement" },
      { mode = 'v', "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  desc = "vDecrement" },
      { mode = 'v', "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "gvIncrement" },
      { mode = 'v', "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "gvDecrement" },
    },
  },

  {
    "shellRaining/hlchunk.nvim",
    config = function()
      require("hlchunk").setup {
        chunk = {
          enable = true,
          style = {
            { fg = "#22A0A0" },
            { fg = "#CC2233" },
          },
          use_treesitter = true,
          chars = {
            horizontal_line = "─",
            vertical_line = "│",
            left_top = "┌",
            left_bottom = "└",
            right_arrow = ">",
          },
          textobject = "",
          max_file_size = 1024 * 1024,
          error_sign = true,
          delay = 0,
        },
        indent = {
          enable = false,
        },
      }
    end,
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
    "petertriho/nvim-scrollbar",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    event = 'VeryLazy',
    config = function()
      require("scrollbar").setup {
        show = true,
        show_in_active_only = false,
        set_highlights = true,
        folds = 1000,
        max_lines = false,
        hide_if_all_visible = true,
        throttle_ms = 100,
        handle = {
          text = " ",
          blend = 60,
          color = nil,
          color_nr = nil,
          highlight = "CursorColumn",
          hide_if_all_visible = true,
        },
        marks = {
          Cursor = {
            text = "•",
            priority = 0,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          Search = {
            text = { "-", "=" },
            priority = 1,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Search",
          },
          Error = {
            text = { "-", "=" },
            priority = 2,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextError",
          },
          Warn = {
            text = { "-", "=" },
            priority = 3,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextWarn",
          },
          Info = {
            text = { "-", "=" },
            priority = 4,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextInfo",
          },
          Hint = {
            text = { "-", "=" },
            priority = 5,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "DiagnosticVirtualTextHint",
          },
          Misc = {
            text = { "-", "=" },
            priority = 6,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "Normal",
          },
          GitAdd = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsAdd",
          },
          GitChange = {
            text = "┆",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsChange",
          },
          GitDelete = {
            text = "▁",
            priority = 7,
            gui = nil,
            color = nil,
            cterm = nil,
            color_nr = nil,
            highlight = "GitSignsDelete",
          },
        },
        excluded_buftypes = {
          "terminal",
        },
        excluded_filetypes = {
          "dropbar_menu",
          "dropbar_menu_fzf",
          "DressingInput",
          "cmp_docs",
          "cmp_menu",
          "noice",
          "prompt",
          "TelescopePrompt",
        },
        autocmd = {
          render = {
            "BufWinEnter",
            "TabEnter",
            "TermEnter",
            "WinEnter",
            "CmdwinLeave",
            "TextChanged",
            "VimResized",
            "WinScrolled",
          },
          clear = {
            "BufWinLeave",
            "TabLeave",
            "TermLeave",
            "WinLeave",
          },
        },
        handlers = {
          cursor = true,
          diagnostic = true,
          gitsigns = true,
          handle = true,
          search = true,
          ale = false,
        },
      }
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
