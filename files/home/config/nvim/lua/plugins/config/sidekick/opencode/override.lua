local M = {}

local methods = { "close", "focus", "hide", "prompt", "render", "select", "send", "show", "toggle" }

local overrides = {}

local function is_opencode(opts)
    return type(opts) == "table" and opts.name == "opencode"
end

function M.setup(api)
    local cli = require "sidekick.cli"

    for _, name in ipairs(methods) do
        local original = cli[name]
        local override = overrides[name]

        cli[name] = function(opts, ...)
            if override and is_opencode(opts) then
                vim.notify("Overriding sidekick.cli." .. name, vim.log.levels.DEBUG, { title = "Sidekick" })
                return override(original, api, opts, ...)
            end
            return original(opts, ...)
        end
    end
end

return M
