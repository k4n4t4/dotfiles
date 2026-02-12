local M = {}

local group = vim.api.nvim_create_augroup("Utils_highlight", { clear = true })

M.registry = {}

function M.set(group_name, opts)
    M.registry[group_name] = opts
    vim.api.nvim_set_hl(0, group_name, opts)
end

function M.use(group_name)
    return "%#" .. group_name .. "#"
end

function M.refresh()
    for name, opts in pairs(M.registry) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

vim.api.nvim_create_autocmd({"VimEnter", "ColorScheme"}, {
    group = group;
    callback = function()
        M.refresh()
    end;
})

return M
