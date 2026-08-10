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

set({ 'n', 'x' }, '<leader>a', function()
    vim.cmd.normal { "ggVoG", bang = true }
end, { desc = "Select All" })

set({ 'n', 'x' }, '<C-p>', function()
    vim.cmd.normal { "p`[v`]=", bang = true }
end, { desc = "Paste after cursor and auto-indent" })
set({ 'n', 'x' }, '<C-S-p>', function()
    vim.cmd.normal { "P`[v`]=", bang = true }
end, { desc = "Paste before cursor and auto-indent" })

-- mark keymaps
vim.keymap.set('n', 'dM', function()
    vim.cmd.delmarks { bang = true }
    vim.cmd.redraw { bang = true }
end, { desc = "Delete all local marks and redraw" })
vim.keymap.set('n', 'dm', function()
    local char = vim.fn.getcharstr()
    if char:match("[a-zA-Z0-9]") then
        vim.cmd.delmarks(char)
        vim.cmd.redraw { bang = true }
    end
end, { desc = "Delete a specific mark and redraw" })
vim.keymap.set('n', 'm', function()
    local char = vim.fn.getcharstr()
    if char:match("[a-zA-Z0-9]") then
        vim.cmd.normal { "m" .. char, bang = true }
        vim.cmd.redraw { bang = true }
    end
end, { desc = "Set a mark and redraw" })

-- visual mode keymaps
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

-- swap selected texts
do
    local visual_swap = require('utils.visual-swap')
    local pending = nil
    local hl_ns = vim.api.nvim_create_namespace("VisualSwapPending")
    vim.api.nvim_set_hl(0, "VisualSwapPendingHighlight", { link = "IncSearch" })
    vim.keymap.set('x', '<leader>s', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local range = visual_swap.visual_range(bufnr)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)

        if not pending then
            local extmark_id = vim.api.nvim_buf_set_extmark(bufnr, hl_ns, range[1], range[2], {
                end_row = range[3],
                end_col = range[4],
                hl_group = "VisualSwapPendingHighlight",
            })
            pending = {
                bufnr = bufnr,
                range = range,
                extmark_id = extmark_id
            }
            return
        end
        visual_swap.swap(pending.bufnr, pending.range, bufnr, range)
        vim.api.nvim_buf_del_extmark(pending.bufnr, hl_ns, pending.extmark_id)
        pending = nil
    end, { desc = "Swap selected texts" })
end

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
        set('n', '<Leader>la', vim.lsp.buf.code_action, { buffer = buf, desc = "Code Action" })
        set('n', '<Leader>lr', vim.lsp.buf.references, { buffer = buf, desc = "References" })
        set('n', '<Leader>li', vim.lsp.buf.implementation, { buffer = buf, desc = "Implementation" })
        set('n', '<Leader>lD', vim.lsp.buf.declaration, { buffer = buf, desc = "Declaration" })
        set('n', 'K', vim.lsp.buf.hover, { buffer = buf, desc = "Hover" })
        set('n', '<C-K>', vim.lsp.buf.signature_help, { buffer = buf, desc = "Signature Help" })
    end,
})


-- diagnostic keymaps
set('n', '<C-S-k>', vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
set('n', '<Leader>df', vim.diagnostic.open_float, { desc = "Open Diagnostic Float" })
set('n', '<Leader>dl', vim.diagnostic.setloclist, { desc = "Set Loclist" })
set('n', '<Leader>dq', vim.diagnostic.setqflist, { desc = "Set Qflist" })


-- set keymaps for unlisted filetypes
local function unlist_filetype_keymaps(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = event.buf, silent = true })
end
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
    callback = unlist_filetype_keymaps,
})
-- set keymaps for cmdwin
autocmd("CmdwinEnter", {
    group = augroup("Cmdwin Keymaps", { clear = true }),
    callback = unlist_filetype_keymaps
})
