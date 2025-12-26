local utils_fold = require "utils.fold"

return function()
    if utils_fold then
        local winnr = vim.api.nvim_get_current_win()
        local fi = utils_fold.get(winnr, vim.v.lnum)

        if fi.lnum == vim.v.lnum then
            if vim.v.virtnum == 0 then
                if fi.folded then
                    return "%#StatusColumnFoldHead#>%*"
                end
                return "%#StatusColumnFoldHead#v%*"
            end
            return "%#StatusColumnFold#¦%*"
        end

        if fi.level ~= 0 then
            return "%#StatusColumnFold#¦%*"
        end

        return " "
    end

    return "%C"
end
