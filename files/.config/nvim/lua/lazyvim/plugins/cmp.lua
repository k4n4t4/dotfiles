return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-emoji",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-git",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",

      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        window = {
          completion = {
            border = 'single',
          },
          documentation = {
            border = 'double',
          },
        },
        experimental = {
          ghost_text = false,
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
          { name = 'git' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-e>'] = cmp.mapping.abort(),
          ['<S-TAB>'] = cmp.mapping.select_prev_item(),
          ['<TAB>'] = cmp.mapping.select_next_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
        }),
      }
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'buffer' },
        }
      })
      cmp.setup.cmdline({':', '@', '-', '=', '>'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources {
          { name = 'path' },
          { name = 'cmdline' },
          { name = 'buffer' },
        },
        matching = { disallow_symbol_nonprefix_matching = false }
      })
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    event = {
      'InsertEnter',
      'CmdlineEnter',
    },
    cmd = "CmpStatus",
  },
}
