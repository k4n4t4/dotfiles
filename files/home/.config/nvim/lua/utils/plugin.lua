local M = {}

local cache = {}
local pending = {}


--- @param plugin_name string
--- @param event string
--- @return any|nil
function M.load(plugin_name, event)
    if cache[plugin_name] then
        return cache[plugin_name]
    elseif pending[plugin_name] then
        return nil
    end

    pending[plugin_name] = true

    local group = vim.api.nvim_create_augroup("LazyLoad_" .. plugin_name, { clear = true })
    vim.api.nvim_create_autocmd(event, {
        group = group,
        once = true,
        callback = vim.schedule_wrap(function()
            local ok, mod = pcall(require, plugin_name)
            if ok then
                cache[plugin_name] = mod
            end
            pending[plugin_name] = nil
        end),
    })

    return nil
end

--- @param plugin_name string
--- @return any|nil
function M.get(plugin_name)
    return cache[plugin_name]
end

return M
