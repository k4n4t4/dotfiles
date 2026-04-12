local lsp = require "utils.lsp"

local cmd = { "emmet-language-server", "--stdio" }

if not lsp.is_cmd_available(cmd) then return {} end

return {
    cmd = cmd,
    filetypes = {
        "css",
        "eruby",
        "html",
        "jsp",
        "javascript",
        "javascriptreact",
        "less",
        "sass",
        "scss",
        "pug",
        "typescriptreact"
    },
}
