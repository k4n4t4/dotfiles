vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = function()
        vim.diagnostic.config {
            virtual_text = true,
            update_in_insert = false,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "!",
                    [vim.diagnostic.severity.WARN] = "*",
                    [vim.diagnostic.severity.INFO] = "i",
                    [vim.diagnostic.severity.HINT] = "?",
                },
            },
        }
    end,
})

local hl = require "utils.highlight"
hl.set("DiagnosticUnnecessary", { link = "NONE", default = false })
