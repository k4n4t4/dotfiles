return function()
    if vim.v.virtnum == 0 then
        if vim.wo.relativenumber then
            if vim.v.lnum == vim.fn.line(".") then
                return tostring(vim.v.lnum)
            end
            return tostring(vim.v.relnum)
        end
        return tostring(vim.v.lnum)
    end
    return "▕"
end
