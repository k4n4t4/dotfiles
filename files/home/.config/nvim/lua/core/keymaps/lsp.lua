local group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
local keymap = vim.keymap
local set = keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(event)
        local buf = event.buf
        set('n', 'K', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>lr', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lh', vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lg', vim.lsp.buf.references, { buffer = buf, desc = "References" })
        set('n', '<Leader>ls', vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
        set('n', '<Leader>le', function() vim.lsp.diagnostic.show_line_diagnostics() end,
            { buffer = buf, desc = "Show Line Diagnostics" })
        set('n', '<Leader>l[', function() vim.lsp.diagnostic.goto_prev() end,
            { buffer = buf, desc = "Diagnostic Goto Prev" })
        set('n', '<Leader>l]', function() vim.lsp.diagnostic.goto_next() end,
            { buffer = buf, desc = "Diagnostic Goto Next" })
    end
})
