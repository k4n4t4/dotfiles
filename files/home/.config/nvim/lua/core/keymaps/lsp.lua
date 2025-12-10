local keymap = vim.keymap
local set = keymap.set

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local buf = event.buf
    set('n', '<LEADER>lf', vim.lsp.buf.format,          { buffer = buf, desc = "Format" })
    set('n', '<LEADER>lr', vim.lsp.buf.rename,          { buffer = buf, desc = "Rename" })
    set('n', '<LEADER>ld', vim.lsp.buf.definition,      { buffer = buf, desc = "Definition" })
    set('n', '<LEADER>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
    set('n', '<LEADER>lh', vim.lsp.buf.hover,           { buffer = buf, desc = "Hover" })
    set('n', '<LEADER>lc', vim.lsp.buf.code_action,     { buffer = buf, desc = "Code Action" })
    set('n', '<LEADER>lg', vim.lsp.buf.references,      { buffer = buf, desc = "References" })
    set('n', '<LEADER>ls', vim.lsp.buf.signature_help,  { buffer = buf, desc = "Signature Help" })
    set('n', '<LEADER>le', function() vim.lsp.diagnostic.show_line_diagnostics() end, { buffer = buf, desc = "Show Line Diagnostics" })
    set('n', '<LEADER>l[', function() vim.lsp.diagnostic.goto_prev() end, { buffer = buf, desc = "Diagnostic Goto Prev" })
    set('n', '<LEADER>l]', function() vim.lsp.diagnostic.goto_next() end, { buffer = buf, desc = "Diagnostic Goto Next" })
  end
})
