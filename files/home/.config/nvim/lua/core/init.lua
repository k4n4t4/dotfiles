require "core.options"
require "core.disable_plugins"
require "core.netrw"
require "core.keymaps"
if not vim.g.vscode then
  require "core.autocmd"
  require "core.ui"
end
require "core.settings"
