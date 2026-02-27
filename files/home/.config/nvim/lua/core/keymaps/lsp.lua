local group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true })
local keymap = vim.keymap
local set = keymap.set

local function hover()
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result)
        if not (result and result.contents) then return end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        if vim.tbl_isempty(markdown_lines) then return end
        local _, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", {
            border = "none",
            focusable = true,
        })
        vim.wo[winid].winblend = 10
    end)
end

local function signature_help()
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(_, result)
        if not (result) then return end
        local markdown_lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result, vim.bo.filetype) or {}
        if vim.tbl_isempty(markdown_lines) then return end
        local _, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", {
            border = "none",
            focusable = true,
        })
        vim.wo[winid].winblend = 10
    end)
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = vim.schedule_wrap(function(event)
        local buf = event.buf
        set('n', '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>lr', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lg', vim.lsp.buf.references, { buffer = buf, desc = "References" })

        set('n', '<Leader>lh', function() hover() end, { buffer = buf, desc = "Hover" })
        set('n', '<Leader>ls', function() signature_help() end, { buffer = buf, desc = "Signature Help" })
        set('n', 'K', function() hover() end, { buffer = buf, desc = "Hover" })
        set('n', '<C-k>', function() signature_help() end, { buffer = buf, desc = "Signature Help" })

        set('n', 'gd', function() vim.lsp.buf.definition() end, { buffer = buf, desc = "Definition" })
        set('n', 'gD', function() vim.lsp.buf.declaration() end, { buffer = buf, desc = "Declaration" })
        set('n', 'gr', function() vim.lsp.buf.references() end, { buffer = buf, desc = "References" })
        set('n', 'gi', function() vim.lsp.buf.implementation() end, { buffer = buf, desc = "Implementation" })

        set('n', '<Leader>le', function() vim.lsp.diagnostic.show_line_diagnostics() end,
            { buffer = buf, desc = "Show Line Diagnostics" })
        set('n', '<Leader>l[', function() vim.lsp.diagnostic.goto_prev() end,
            { buffer = buf, desc = "Diagnostic Goto Prev" })
        set('n', '<Leader>l]', function() vim.lsp.diagnostic.goto_next() end,
            { buffer = buf, desc = "Diagnostic Goto Next" })
    end),
})
