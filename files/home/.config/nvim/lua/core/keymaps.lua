local set = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = function()
        set({ 'n', 'o', 'x' }, '<tab>', "5j", { desc = "Scroll Down" })
        set({ 'n', 'o', 'x' }, '<S-tab>', "5k", { desc = "Scroll Up" })

        set({ 'n', 'x' }, '<leader>w', "<C-w><C-w>", { desc = "Switch Window" })

        set('n', '<leader>H', "<cmd>noh<cr>", { desc = "No hlsearch" })

        set({ 'n', 'x' }, '<leader>a', "ggVoG", { desc = "Select All" })

        set('n', '<M-n>', vim.cmd.enew, { desc = "Tabuf New" })
        set('n', '<M-j>', require "utils.tabuf".next, { desc = "Tabuf Next" })
        set('n', '<M-k>', require "utils.tabuf".prev, { desc = "Tabuf Prev" })
        set('n', '<M-x>', require "utils.tabuf".close, { desc = "Tabuf Close" })
        set('n', '<M-t>', vim.cmd.tabnew, { desc = "Tabuf New" })
        set('n', '<M-h>', vim.cmd.tabprevious, { desc = "Tab Left" })
        set('n', '<M-l>', vim.cmd.tabnext, { desc = "Tab Right" })
        set('n', '<M-S-x>', vim.cmd.tabclose, { desc = "Tab Close" })

        set('n', '<leader>T', require "utils.transparent".toggle, { desc = "Toggle Transparency" })

        set("x", "A",
            function()
                if vim.fn.mode(0) == "V" then
                    return "<C-v>0o$A"
                else
                    return "A"
                end
            end,
            { expr = true, desc = "Append to end of line in visual mode" }
        )
        set("x", "I",
            function()
                if vim.fn.mode(0) == "V" then
                    return "<C-v>0o^I"
                else
                    return "I"
                end
            end,
            { expr = true, desc = "Insert at beginning of line in visual mode" }
        )
    end,
})


vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
    callback = vim.schedule_wrap(function(event)
        local buf = event.buf
        if vim.b[buf].lsp_keymap_mapped then return end
        vim.b[buf].lsp_keymap_mapped = true

        local lsp = require "utils.lsp"

        set('n', '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>ln', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lr', vim.lsp.buf.references, { buffer = buf, desc = "References" })
        set('n', '<Leader>li', vim.lsp.buf.implementation, { buffer = buf, desc = "Implementation" })
        set('n', '<Leader>lD', vim.lsp.buf.declaration, { buffer = buf, desc = "Declaration" })

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
        set('n', 'gi', function() vim.lsp.buf.implementation() end, { buffer = buf, desc = "Implementation" })
    end),
})
