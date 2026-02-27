local start = vim.uv.hrtime()
vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = function()
        local finish = vim.uv.hrtime()
        vim.g.startup_time = tostring((finish - start) / 1e6) .. "ms"
    end,
})


vim.loader.enable()
require"utils.disable_plugins".setup()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")
