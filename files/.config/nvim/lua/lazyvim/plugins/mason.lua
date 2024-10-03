return {
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local mason = require "mason"
      local mason_lspconfig = require "mason-lspconfig"
      local lspconfig = require "lspconfig"

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
      }

      local server_names = mason_lspconfig.get_installed_servers()

      for _, server_name in ipairs(server_names) do
        lspconfig[server_name].setup {}
      end

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
