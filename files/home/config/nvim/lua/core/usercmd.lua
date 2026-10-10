local usercmd = vim.api.nvim_create_user_command

-- list lsp
usercmd("LspList", function()
    local str = ""
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        str = str .. "No active LSP clients\n"
    else
        str = str .. "Active LSP clients:\n"
        for _, client in ipairs(clients) do
            str = str .. (string.format("  - %s (id: %d)", client.name, client.id)) .. "\n"
        end
    end
    vim.notify(str:sub(1, -2))
end, { desc = "List active LSP clients" })

-- dir config
require("utils.dir-config").setup()
