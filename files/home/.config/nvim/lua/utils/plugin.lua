local M = {}


local cache = {}

function M.use(plugin_name)
    if cache[plugin_name] ~= nil then
        return cache[plugin_name]
    end

    local ok, plugin = pcall(require, plugin_name)
    if ok then
        cache[plugin_name] = plugin
        return plugin
    else
        cache[plugin_name] = nil
        return nil
    end
end

function M.setup(plugin_name, opts)
    local plugin = M.use(plugin_name)
    if plugin and plugin.setup then
        plugin.setup(opts or {})
        return plugin
    end
    return nil
end

return M
