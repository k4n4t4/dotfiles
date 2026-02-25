local M = {}

local cache = {}
local pending = {}


--- Schedules a plugin to be loaded on the first occurrence of the given event.
--- Returns the cached module immediately if it has already been loaded, or `nil` while pending.
--- @param plugin_name string Lua module name to require (e.g. "nvim-treesitter")
--- @param event string Neovim autocmd event that triggers the load (e.g. "BufReadPost")
--- @return any|nil The loaded module, or nil if not yet available
function M.load(plugin_name, event, pattern)
    if cache[plugin_name] then
        return cache[plugin_name]
    elseif pending[plugin_name] then
        return nil
    end

    pending[plugin_name] = true


    local group = vim.api.nvim_create_augroup("LazyLoad_" .. plugin_name, { clear = true })
    vim.api.nvim_create_autocmd(event, {
        group = group,
        pattern = pattern or "*",
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

--- Returns a previously loaded plugin module from cache, or nil if not yet loaded.
--- @param plugin_name string Lua module name
--- @return any|nil
function M.get(plugin_name)
    return cache[plugin_name] or nil
end

return M
