vim.loader.enable()

require "utils.startup_time".setup { show = true }

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "plugins"
    require "core"
end

--[[ STATUSCOLUMN ]]--
local stc = require "utils.stc"

stc.setup {
    statuscolumn = function(ctx)
        return "AAA"
    end,

}
