local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- general keymaps
set({ 'n', 'o', 'x' }, '<tab>', "5j", { desc = "Scroll Down" })
set({ 'n', 'o', 'x' }, '<S-tab>', "5k", { desc = "Scroll Up" })

set('n', '<C-S-o>', '<C-i>')

set({ 'n', 'x' }, '<leader>w', "<C-w><C-w>", { desc = "Switch Window" })

set('n', '<leader>H', "<cmd>noh<cr>", { desc = "No hlsearch" })

set({ 'n', 'x' }, '<leader>a', "ggVoG", { desc = "Select All" })

set("x", "A", function()
    if vim.fn.mode(0) == "V" then
        return "<C-v>0o$A"
    else
        return "A"
    end
end, { expr = true, desc = "Append to end of line in visual mode" })
set("x", "I", function()
    if vim.fn.mode(0) == "V" then
        return "<C-v>0o^I"
    else
        return "I"
    end
end, { expr = true, desc = "Insert at beginning of line in visual mode" })

-- lsp keymaps
autocmd("LspAttach", {
    group = augroup("Lsp Keymaps", { clear = true }),
    callback = function(event)
        local buf = event.buf
        if vim.b[buf].lsp_keymap_mapped then return end
        vim.b[buf].lsp_keymap_mapped = true

        set({'n', 'x'}, '<Leader>lf', vim.lsp.buf.format, { buffer = buf, desc = "Format" })
        set('n', '<Leader>ln', vim.lsp.buf.rename, { buffer = buf, desc = "Rename" })
        set('n', '<Leader>ld', vim.lsp.buf.definition, { buffer = buf, desc = "Definition" })
        set('n', '<Leader>lt', vim.lsp.buf.type_definition, { buffer = buf, desc = "Type Definition" })
        set('n', '<Leader>lc', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lr', vim.lsp.buf.references, { buffer = buf, desc = "References" })
        set('n', '<Leader>li', vim.lsp.buf.implementation, { buffer = buf, desc = "Implementation" })
        set('n', '<Leader>lD', vim.lsp.buf.declaration, { buffer = buf, desc = "Declaration" })
        set('n', '<Leader>lh', vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
        set('n', '<Leader>ls', vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
        set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
        set('n', '<C-K>', vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
    end,
})

-- set keymaps for unlisted filetypes
autocmd("FileType", {
    group = augroup("UnlistFileType Keymaps", { clear = true }),
    pattern = {
        "help",
        "man",
        "lspinfo",
        "checkhealth",
        "qf",
        "query",
        "scratch",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
-- set keymaps for cmdwin
autocmd("CmdwinEnter", {
    group = augroup("Cmdwin Keymaps", { clear = true }),
    callback = function(args)
        vim.keymap.set("n", "q", "<Cmd>quit<CR>", { buffer = args.buf })
    end,
})
