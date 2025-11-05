return function()
  local mason_lspconfig = require("mason-lspconfig")

  vim.lsp.config("lua_ls", {
    filetypes = { "lua" };
    settings = {
      Lua = {
        cmd = { "lua-language-server" };
        runtime = {
          version = "LuaJIT";
          pathStrict = true;
          path = { "?.lua", "?/init.lua" };
        };
        workspace = {
          library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
            vim.fn.stdpath("config") .. "/lua",
            vim.env.VIMRUNTIME .. "/lua",
            "${3rd}/luv/library",
            "${3rd}/busted/library",
            "${3rd}/luassert/library",
          });
          checkThirdParty = "Disable";
        };
      };
    };
  })
  vim.lsp.enable("lua_ls")

  vim.lsp.config("emmet_language_server", {
    filetypes = { "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact" };
    init_options = {
      includeLanguages = {};
      excludeLanguages = {};
      extensionsPath = {};
      preferences = {};
      showAbbreviationSuggestions = true;
      showExpandedAbbreviation = "always";
      showSuggestionsAsSnippets = false;
      syntaxProfiles = {};
      variables = {};
    };
  })
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
