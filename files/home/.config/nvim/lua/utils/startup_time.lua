local M = {}

function M.setup()
    vim.g.startup_time = 0
    local start = vim.uv.hrtime()
    vim.api.nvim_create_autocmd("SafeState", {
        once = true,
        callback = function()
            local finish = vim.uv.hrtime()
            vim.g.startup_time = finish - start
        end,
    })
end

function M.get()
    return (vim.g.startup_time / 1e6) .. "ms"
end

return M
