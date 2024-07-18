return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-cmdline" },
      { "hrsh7th/vim-vsnip" },
      { "hrsh7th/cmp-vsnip" },
      { "onsails/lspkind.nvim" },
    },
    event = "InsertEnter",
    config = function()
      local lspkind = require "lspkind"
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "vsnip" },
          { name = "buffer" },
          { name = "path" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<S-TAB>"] = cmp.mapping.select_prev_item(),
          ["<TAB>"] = cmp.mapping.select_next_item(),
          ["<C-l>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<CR>" ] = cmp.mapping.confirm({ select = false }),
        }),
        experimental = {
          ghost_text = false,
        },
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
          })
        }
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end,
  },
}
