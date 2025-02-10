return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = 'double',
      },
    },
    cmd = {
      "Mason",
      "MasonUpdate",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonLog",
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/nvim-lsp-installer",
      "neovim/nvim-lspconfig",
      "nvimtools/none-ls.nvim",
      "jayp0521/mason-null-ls.nvim",
    },
    config = function()
      local lspconfig = require "lspconfig"
      local mason_lspconfig = require "mason-lspconfig"

      require("nvim-lsp-installer").setup {
        automatic_installation = true,
        ui = {
          icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
          }
        }
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
          end,
          rust_analyzer = function()
            lspconfig.rust_analyzer.setup = function()
              return true
            end
          end,
        },
      }

      lspconfig.emmet_language_server.setup {
        filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" },
        init_options = {
          includeLanguages = {},
          excludeLanguages = {},
          extensionsPath = {},
          preferences = {},
          showAbbreviationSuggestions = true,
          showExpandedAbbreviation = "always",
          showSuggestionsAsSnippets = false,
          syntaxProfiles = {},
          variables = {},
        },
      }

    end,
    event = { "BufReadPre", "BufNewFile" },
  },

  {
    "mrcjkb/rustaceanvim",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
    },
    version = '^5',
    lazy = false,
    ft = "rust",
    config = function()
      local lspconfig = require "lspconfig"
      vim.g.rustaceanvim = {
        tools = {
          enable_clippy = true,
        },
        server = {
          auto_attach = true,
          root_dir = lspconfig.util.root_pattern("Cargo.toml")
        },
      }
    end,
  },
}
