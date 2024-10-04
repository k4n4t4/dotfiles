return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "jayp0521/mason-null-ls.nvim",
      "nvimtools/none-ls.nvim",
    },
    config = function()
      local lspconfig = require "lspconfig"
      local mason = require "mason"
      local mason_lspconfig = require "mason-lspconfig"

      mason.setup {
        ui = {
          border = 'double',
        },
      }

      mason_lspconfig.setup {
        ensure_installed = {
          "lua_ls",
          "vimls",
          "pylsp",
          "bashls",
        },
        automatic_installation = false,
        handlers = {
          function(server_name)
            lspconfig[server_name].setup {}
          end,
          lua_ls = function()
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
          end
        },
      }
    end,
  },
}
