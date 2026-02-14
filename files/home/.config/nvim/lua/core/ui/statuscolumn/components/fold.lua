local utils_fold = require "utils.fold"

function ToggleFold()
    local line = vim.fn.getmousepos().line
    if vim.fn.foldlevel(line) > 0 then
        if vim.fn.foldclosed(line) ~= -1 then
            vim.cmd(line .. "foldopen")
        else
            vim.cmd(line .. "foldclose")
        end
    end
end

return function()
    if utils_fold then
        local s = ""

        local winnr = vim.g.statusline_winid
        local fi = utils_fold.get(winnr, vim.v.lnum)

        s = s .. "%@v:lua.ToggleFold@"
        if fi.lnum == vim.v.lnum then
            if vim.v.virtnum == 0 then
                if fi.folded then
                    s = s .. "%#StatusColumnFoldHead#>%*"
                else
                    s = s .. "%#StatusColumnFoldHead#v%*"
                end
            else
                s = s .. "%#StatusColumnFold#¦%*"
            end
        elseif fi.level ~= 0 then
            s = s .. "%#StatusColumnFold#¦%*"
        else
            s = s .. " "
        end
        s = s .. "%X"

        return s
    end

    return "%C"
end
