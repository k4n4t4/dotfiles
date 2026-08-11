local usercmd = vim.api.nvim_create_user_command

-- list lsp
usercmd("LspList", function()
    local clients = vim.lsp.get_clients()
    if #clients == 0 then
        print "No active LSP clients"
        return
    end
    print "Active LSP clients:"
    for _, client in ipairs(clients) do
        print(string.format("  - %s (id: %d)", client.name, client.id))
    end
end, { desc = "List active LSP clients" })
