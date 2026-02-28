local set = vim.keymap.set

vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = function()
        set({ 'n', 'o', 'x' }, '<tab>', "5j", { desc = "Scroll Down" })
        set({ 'n', 'o', 'x' }, '<S-tab>', "5k", { desc = "Scroll Up" })

        set({ 'n', 'x' }, '<leader>w', "<C-w><C-w>", { desc = "Switch Window" })

        set('n', '<leader>H', "<cmd>noh<cr>", { desc = "No hlsearch" })

        set({ 'n', 'x' }, '<leader>a', "ggVoG", { desc = "Select All" })

        set('n', '<M-j>', require "utils.tabuf".next, { desc = "Tabuf Next" })
        set('n', '<M-k>', require "utils.tabuf".prev, { desc = "Tabuf Prev" })
        set('n', '<M-x>', require "utils.tabuf".close, { desc = "Tabuf Close" })
        set('n', '<M-h>', vim.cmd.tabprevious, { desc = "Tab Left" })
        set('n', '<M-l>', vim.cmd.tabnext, { desc = "Tab Right" })
        set('n', '<M-S-x>', vim.cmd.tabclose, { desc = "Tab Close" })

        set('n', '<leader>T', require "utils.transparent".toggle)
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
    callback = vim.schedule_wrap(function(event)
        local lsp = require "utils.lsp"
        local buf = event.buf

        set('n', '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>lr', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lg', vim.lsp.buf.references, { buffer = buf, desc = "References" })

        set('n', '<Leader>lh', function()
            lsp.hover {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Hover" })
        set('n', '<Leader>ls', function()
            lsp.signature_help {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Signature Help" })
        set('n', 'K', function()
            lsp.hover {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Hover" })
        set('n', '<C-k>', function()
            lsp.signature_help {
                border = "none",
                focusable = true,
                winblend = 10,
            }
        end, { buffer = buf, desc = "Signature Help" })

        set('n', 'gd', function() vim.lsp.buf.definition() end, { buffer = buf, desc = "Definition" })
        set('n', 'gD', function() vim.lsp.buf.declaration() end, { buffer = buf, desc = "Declaration" })
        set('n', 'gr', function() vim.lsp.buf.references() end, { buffer = buf, desc = "References" })
        set('n', 'gi', function() vim.lsp.buf.implementation() end, { buffer = buf, desc = "Implementation" })
    end),
})
