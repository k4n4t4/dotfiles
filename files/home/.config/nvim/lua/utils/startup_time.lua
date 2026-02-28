local M = {}

function M.setup(opts)
    opts = opts or {}
    vim.g.startup_time = 0
    local start = vim.uv.hrtime()
    vim.api.nvim_create_autocmd(opts.event or "SafeState", {
        once = true,
        callback = function()
            local finish = vim.uv.hrtime()
            vim.g.startup_time = finish - start
            if opts.show then
                vim.notify("Startup Time: " .. M.get())
            end
        end,
    })
end

function M.get()
    return (vim.g.startup_time / 1e6) .. "ms"
end

return M
