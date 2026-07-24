return {
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' }
        }
    },
    on_init = function(client)
        if client.config.settings then
            client:notify('workspace/didChangeConfiguration', {
                settings = client.config.settings
            })
        end
    end,
}
