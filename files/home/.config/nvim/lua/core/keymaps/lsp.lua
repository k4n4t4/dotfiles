local group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
local keymap = vim.keymap
local set = keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
        local buf = event.buf
        set('n', '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>lr', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lg', vim.lsp.buf.references, { buffer = buf, desc = "References" })

        set('n', '<Leader>lh', function()
            vim.lsp.buf.hover {
                border = "none",
                winblend = 10,
                focusable = true,
            }
        end, { buffer = buf, desc = "Hover" })

        set('n', '<Leader>ls', function()
            vim.lsp.buf.signature_help {
                border = "none",
                winblend = 10,
                focusable = true,
            }
        end, { buffer = buf, desc = "Signature Help" })

        set('n', 'K', function()
            vim.lsp.buf.hover {
                border = "none",
                winblend = 10,
                focusable = true,
            }
        end, { buffer = buf, desc = "Hover" })

        set('n', '<C-k>', function()
            vim.lsp.buf.signature_help {
                border = "none",
                winblend = 10,
                focusable = true,
            }
        end, { buffer = buf, desc = "Signature Help" })

        set('n', 'gd', function()
            vim.lsp.buf.definition()
        end, { buffer = buf, desc = "Definition" })

        set('n', 'gD', function()
            vim.lsp.buf.declaration()
        end, { buffer = buf, desc = "Declaration" })

        set('n', 'gr', function()
            vim.lsp.buf.references()
        end, { buffer = buf, desc = "References" })

        set('n', 'gi', function()
            vim.lsp.buf.implementation()
        end, { buffer = buf, desc = "Implementation" })

        set('n', '<Leader>le', function() vim.lsp.diagnostic.show_line_diagnostics() end, { buffer = buf, desc = "Show Line Diagnostics" })
        set('n', '<Leader>l[', function() vim.lsp.diagnostic.goto_prev() end, { buffer = buf, desc = "Diagnostic Goto Prev" })
        set('n', '<Leader>l]', function() vim.lsp.diagnostic.goto_next() end, { buffer = buf, desc = "Diagnostic Goto Next" })
    end
})
