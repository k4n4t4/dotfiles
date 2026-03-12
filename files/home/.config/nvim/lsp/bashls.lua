local lsp = require "utils.lsp"

local cmd = { "bash-language-server", "start" }

if not lsp.is_cmd_available(cmd) then return nil end

return {
    cmd = cmd,
    filetypes = { "sh", "bash" },
    settings = {
        bash = {
            enable = true,
            executionCommand = {},
            ignorePatterns = {},
            ignoreWarnings = {},
            excludePaths = {},
        },
    },
}
