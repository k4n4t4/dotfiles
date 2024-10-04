return {

  -- colorschemes
  {
    "navarasu/onedark.nvim",
    enabled = true,
    opts = {
      style = "darker",
    },
  },
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
  },
  {
    "sainnhe/everforest",
    enabled = true,
    config = function()
      vim.g.everforest_background = 'soft'
    end
  },
  {
    "sainnhe/gruvbox-material",
    enabled = true,
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
    name = "render-markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    ft = "markdown",
  },


  {
    "norcalli/nvim-colorizer.lua",
    event = 'VeryLazy',
  },

  {
    "dstein64/vim-startuptime",
    event = 'VeryLazy',
  },

  {
    "petertriho/nvim-scrollbar",
    event = 'VeryLazy',
    opts = {
      handlers = {
        cursor = true,
        diagnostic = true,
        gitsigns = true,
        handle = true,
        search = false,
        ale = true,
      },
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
}
