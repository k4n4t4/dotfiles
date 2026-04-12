local lsp = require "utils.lsp"

local cmd = { 'vscode-html-language-server', '--stdio' }

if not lsp.is_cmd_available(cmd) then return {} end

return {
  cmd = cmd,
  filetypes = { 'html', 'jsp' },
}
