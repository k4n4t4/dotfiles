return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local on_attach = function(client, bufnr)
        local set = vim.keymap.set
        set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
        set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>")
        --set("n", "<C-m>", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
        set("n", "gy", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
        set("n", "rn", "<cmd>lua vim.lsp.buf.rename()<CR>")
        set("n", "ma", "<cmd>lua vim.lsp.buf.code_action()<CR>")
        set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>")
        set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>")
        set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
        set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
      end
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      require("mason-lspconfig").setup()
      require("mason-lspconfig").setup_handlers {
        function(server_name)
          require("lspconfig")[server_name].setup {
            on_attach = on_attach,
            capabilities = capabilities,
          }
        end,
      }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup {}
      lspconfig.pylsp.setup {}
      lspconfig.bashls.setup {}
    end,
  },
}
