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
        local mode = stl.mode { align = "center" }
        local lsp = stl.lsp()

        return stl.make_str {
            "[",
            {
                hl = mode.hl,
                content = {
                    mode.label,
                }
            },
            "]",
            "[",
            {
                hl = "Number",
                content = {
                    lsp
                }
            },
            "]",
        }
    end,
}
