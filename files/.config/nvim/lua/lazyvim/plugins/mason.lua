return {
  {
    "williamboman/mason.nvim",
    event = 'VeryLazy',
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = 'VeryLazy',
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local mason_lspconfig = require "mason-lspconfig"
      local lspconfig = require "lspconfig"

      mason_lspconfig.setup {
        ensure_installed = {
          "lua_ls",
          "vimls",
        }
      }

      mason_lspconfig.setup_handlers {
        function(server_name)
          lspconfig[server_name].setup {
            on_attach = function()
              local set = vim.keymap.set

              set('n', '<LEADER>lgd', "<CMD>lua vim.lsp.buf.definition()<CR>")
              set('n', '<LEADER>lK', "<CMD>lua vim.lsp.buf.hover()<CR>")
              set('n', '<LEADER>l<C-m>', "<CMD>lua vim.lsp.buf.signature_help()<CR>")
              set('n', '<LEADER>lgy', "<CMD>lua vim.lsp.buf.type_definition()<CR>")
              set('n', '<LEADER>lrn', "<CMD>lua vim.lsp.buf.rename()<CR>")
              set('n', '<LEADER>lma', "<CMD>lua vim.lsp.buf.code_action()<CR>")
              set('n', '<LEADER>lgr', "<CMD>lua vim.lsp.buf.references()<CR>")
              set('n', '<LEADER>le', "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
              set('n', '<LEADER>l[d', "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>")
              set('n', '<LEADER>l]d', "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>")
            end,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          }
        end,
      }

      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              pathStrict = true,
              path = { "?.lua", "?/init.lua" },
            },
            workspace = {
              library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
                vim.fn.stdpath("config") .. "/lua",
                vim.env.VIMRUNTIME .. "/lua",
                "${3rd}/luv/library",
                "${3rd}/busted/library",
                "${3rd}/luassert/library",
              }),
              checkThirdParty = "Disable",
            },
          },
        },
      }
    end,
  },
}
