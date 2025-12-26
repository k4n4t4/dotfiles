return function()
    if vim.v.lnum == vim.fn.line(".") then
        return "%#CursorLineNr#▌%*"
    else
        return "%#LineNr#│%*"
    end
end
