local lsp_show = false

return function(opts)
    opts = opts or {}
    lsp_show = opts.show or lsp_show

    local clients = {}
    local others = {}

    for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
        if client.name == "null-ls" then
            others["null-ls"] = require("utils.lsp").get_null_ls_sources()
        else
            table.insert(clients, client.name)
        end
    end

    if others["null-ls"] and #others["null-ls"] > 0 then
        table.insert(clients, "null-ls:[" .. table.concat(others["null-ls"], ", ") .. "]")
    end

    if #clients == 0 then return end

    return {
        content = lsp_show and table.concat(clients, ", ") or "LSP(" .. #clients .. ")",
        click = {
            name = "stl_toggle_lsp",
            callback = function()
                lsp_show = not lsp_show
                vim.cmd.redrawstatus()
            end,
        },
    }
end
