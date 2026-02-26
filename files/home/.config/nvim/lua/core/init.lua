require "core.options"
require "core.autocmd"
require "core.lsp"
require "core.keymaps"
vim.schedule(function()
    require "core.ui"
end)
