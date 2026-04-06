local M = {}

M.reg = {}

function M.reg.set(name, opts)
    M.reg[name] = opts
end

function M.reg.get(name)
    return M.reg[name]
end

function M.reg.has(name)
    return M.reg[name] ~= nil
end

function M.reg.del(name)
    if M.reg.has(name) then
        M.reg[name] = nil
    end
end

function M.set(name, opts, update)
    M.reg.set(name, opts)
    if update then
        vim.api.nvim_set_hl(M.ns_id, name, opts)
    end
end

function M.get(name)
    local opts = M.reg.get(name)
    if not opts then
        opts = vim.api.nvim_get_hl(M.ns_id, { name = name, link = false })
        M.reg.set(name, opts)
    end
    return opts
end

function M.refresh()
    for name, opts in pairs(M.reg) do
        vim.api.nvim_set_hl(M.ns_id, name, opts)
    end
end

M.ns_id = 0
M.group = vim.api.nvim_create_augroup("hi", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = M.group,
    callback = function()
        M.refresh()
    end,
})

return M
