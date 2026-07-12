vim.loader.enable()

require "utils.startup_time".setup { show = true }

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "plugins"
    require "core"
end


vim.opt.cmdheight = 0
vim.opt.laststatus = 3
local stl = require "utils.stl"
stl.setup {
    statusline = function()
        return stl.make_str {
        }
    end,
}
