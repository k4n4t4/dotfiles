local M = {}

function M.setup(enable_plugins)
    enable_plugins = enable_plugins or {}

    vim.opt.loadplugins = false

    for _, plugin in ipairs(enable_plugins) do
        vim.cmd.runtime("plugin/" .. plugin .. ".lua")
    end
end

return M
