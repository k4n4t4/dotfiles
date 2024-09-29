return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local on_attach = function(client, bufnr)
        local set = vim.keymap.set
        set("n", "<LEADER>lgd", "<CMD>lua vim.lsp.buf.definition()<CR>")
        set("n", "<LEADER>lK", "<CMD>lua vim.lsp.buf.hover()<CR>")
        set("n", "<LEADER>l<C-m>", "<CMD>lua vim.lsp.buf.signature_help()<CR>")
        set("n", "<LEADER>lgy", "<CMD>lua vim.lsp.buf.type_definition()<CR>")
        set("n", "<LEADER>lrn", "<CMD>lua vim.lsp.buf.rename()<CR>")
        set("n", "<LEADER>lma", "<CMD>lua vim.lsp.buf.code_action()<CR>")
        set("n", "<LEADER>lgr", "<CMD>lua vim.lsp.buf.references()<CR>")
        set("n", "<LEADER>le", "<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
        set("n", "<LEADER>l[d", "<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>")
        set("n", "<LEADER>l]d", "<CMD>lua vim.lsp.diagnostic.goto_next()<CR>")
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "vimls",
        }
      }
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end,
      }
      require("lspconfig").lua_ls.setup {}
      require("lspconfig").vimls.setup {}
    end,
  },
}
