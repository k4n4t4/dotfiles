require "core.options"
require "core.keymaps"
if not vim.g.vscode then
  require "core.autocmd"
  require "core.ui"
end
