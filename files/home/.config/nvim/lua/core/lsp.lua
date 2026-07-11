local info = require "utils.info"

local mason_bin = info.path.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
    vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

vim.lsp.enable {
    "html",
    "emmet_language_server",
    "omnisharp",
    "jdtls",
    "ts_ls",
    "powershell_es",
    "lua_ls",
    "bashls",
}

-- filetype
vim.filetype.add {
    extension = {
        jsp = "jsp",
    },
}

-- treesitter
vim.treesitter.language.register("html", "jsp")
