local hi = require "utils.highlight"

function HandleTabClick(tabnr, _, button, _)
    if button == "l" then
        vim.cmd(tabnr .. "tabnext")
    elseif button == "m" then
        vim.cmd(tabnr .. "tabclose")
    end
end

return function(opts)
    local tabnr = opts.tabnr
    local is_active_tab = opts.is_current_tab

    local tabpages = vim.api.nvim_list_tabpages()
    local tabpage = tabpages[tabnr]
    if not tabpage then return "" end

    local tab_hi = hi.use(is_active_tab and "TabLineSel" or "TabLine")

    return table.concat({
        "%", tabnr, "@v:lua.HandleTabClick@",
        tab_hi, " ", tostring(tabnr), " ",
        "%X"
    })
end
