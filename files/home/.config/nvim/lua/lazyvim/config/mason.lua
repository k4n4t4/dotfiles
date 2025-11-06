return function()
  local mason_lspconfig = require("mason-lspconfig")

  vim.lsp.config("lua_ls", require("lazyvim.config.lsp.lua_ls"))
  vim.lsp.enable("lua_ls")

  vim.lsp.config("emmet_language_server", require("lazyvim.config.lsp.emmet_language_server"))
  vim.lsp.enable("emmet_language_server")

  mason_lspconfig.setup {
    ensure_installed = {
      "vimls",
      "pylsp",
      "bashls",
      "ts_ls",
    };
    automatic_enable = true;
  }
end
