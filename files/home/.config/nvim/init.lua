vim.loader.enable()

require "utils.startup_time".setup { show = true }

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core.autocmd"
    require "core.keymaps"
    require "plugins"
    -- require "core.ui"
    require "core.lsp"
    require "core.options"
end
