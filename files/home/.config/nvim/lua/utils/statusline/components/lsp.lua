local utils_lsp = require "utils.lsp"
local lsp_show = false

function StlToggleLspShow()
    lsp_show = not lsp_show
    vim.cmd.redrawstatus()
end

return function()
    local s = ""

    local clients, others = utils_lsp.get(0)
    if others["null-ls"] and #others["null-ls"] > 0 then
        table.insert(clients, "null-ls:[" .. table.concat(others["null-ls"], ", ") .. "]")
    end

    if #clients == 0 then
        return ""
    end

    if not lsp_show then
        s = "LSP(" .. #clients .. ")"
    else
        s = table.concat(clients, ", ")
    end

    return "%@v:lua.StlToggleLspShow@" .. s .. "%X"
end
