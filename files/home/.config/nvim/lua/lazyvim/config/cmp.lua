return function()
  local cmp = require "cmp"
  local lspkind = require "lspkind"
  local luasnip = require "luasnip"

  cmp.setup {
    formatting = {
      format = lspkind.cmp_format {
        mode = "symbol_text";
        menu = {
          copilot       = "[Copilot]";
          string        = "[String]";
          buffer        = "[Buffer]";
          nvim_lsp      = "[LSP]";
          nvim_lua      = "[Lua]";
          luasnip       = "[LuaSnip]";
          latex_symbols = "[Latex]";
          path          = "[Path]";
          git           = "[Git]";
        };
        symbol_map = {
          Copilot      = " ";
          Snippet      = " ";
          String       = " ";
          Buffer       = " ";
          NvimLsp      = " ";
          NvimLua      = " ";
          LuaSnip      = " ";
          LatexSymbols = " ";
          Path         = " ";
          Git          = " ";
        };
      };
    };
    window = {
      completion = {
        -- border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' };
        side_padding = 0;
        col_offset = 0;
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
      };
      documentation = {
        -- border = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' };
        side_padding = 0;
        col_offset = 0;
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None";
      };
    };
    experimental = {
      ghost_text = false;
    };
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end;
    };
    sources = {
      { name = 'copilot' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'nvim_lua' },
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'path' },
      { name = 'git' },
      { name = 'calc' },
      { name = 'mocword' },
      { name = 'treesitter' },
    };
    mapping = cmp.mapping.preset.insert({
      ['<C-e>'] = cmp.mapping.abort();
      ['<S-TAB>'] = cmp.mapping.select_prev_item();
      ['<TAB>'] = cmp.mapping.select_next_item();
      ['<CR>'] = cmp.mapping.confirm({ select = false });
    });
  }

  cmp.setup.cmdline({ '/', '?' }, {
    sources = cmp.config.sources {
      { name = 'buffer' },
    };
    mapping = cmp.mapping.preset.cmdline();
  })

  cmp.setup.cmdline({ ':', '@', '-', '=', '>' }, {
    sources = cmp.config.sources {
      { name = 'path' },
      { name = 'cmdline' },
      { name = 'buffer' },
    };
    mapping = cmp.mapping.preset.cmdline();
    matching = { disallow_symbol_nonprefix_matching = false }
  })

  local hl = vim.api.nvim_set_hl
  hl(0, "CmpItemAbbr", { fg = "#909090", bg = "none" })
  hl(0, "CmpItemAbbrMatch", { fg = "#3333AA", bg = "none" })
  hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#3399AA", bg = "none" })

  require("luasnip.loaders.from_vscode").lazy_load()
end
