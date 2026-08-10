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

do
    local ns_id = vim.api.nvim_create_namespace("VisualSwap")
    local swap_state = nil

    vim.keymap.set('x', '<leader>s', function()
        local saved_z = vim.fn.getreg('z')
        local saved_z_type = vim.fn.getregtype('z')

        vim.cmd.normal { vim.api.nvim_replace_termcodes('<Esc>gv"zy', true, false, true), bang = true }

        local current_text = vim.fn.getreg('z')
        local current_regtype = vim.fn.getregtype('z')
        local current_mode = vim.fn.visualmode()
        local bufnr = vim.api.nvim_get_current_buf()

        if not swap_state then
            local mark_start = vim.api.nvim_buf_get_mark(bufnr, '[')
            local mark_end = vim.api.nvim_buf_get_mark(bufnr, ']')

            local ext1 = vim.api.nvim_buf_set_extmark(bufnr, ns_id, mark_start[1] - 1, mark_start[2], { right_gravity = false })
            local ext2 = vim.api.nvim_buf_set_extmark(bufnr, ns_id, mark_end[1] - 1, mark_end[2], { right_gravity = true })

            swap_state = {
                bufnr = bufnr,
                ext1 = ext1,
                ext2 = ext2,
                text = current_text,
                regtype = current_regtype,
                mode = current_mode
            }

            vim.notify("Swap 1/2 marked", vim.log.levels.INFO)
        else
            vim.fn.setreg('z', swap_state.text, swap_state.regtype)
            vim.cmd.normal { vim.api.nvim_replace_termcodes('gv"zp', true, false, true), bang = true }

            local pos1 = vim.api.nvim_buf_get_extmark_by_id(swap_state.bufnr, ns_id, swap_state.ext1, {})
            local pos2 = vim.api.nvim_buf_get_extmark_by_id(swap_state.bufnr, ns_id, swap_state.ext2, {})

            if #pos1 > 0 and #pos2 > 0 then
                vim.api.nvim_set_current_buf(swap_state.bufnr)

                vim.api.nvim_win_set_cursor(0, { pos1[1] + 1, pos1[2] })
                vim.cmd.normal { swap_state.mode, bang = true }
                vim.api.nvim_win_set_cursor(0, { pos2[1] + 1, pos2[2] })

                vim.fn.setreg('z', current_text, current_regtype)
                vim.cmd.normal { vim.api.nvim_replace_termcodes('"zp', true, false, true), bang = true }

                vim.notify("Swapped", vim.log.levels.INFO)
            else
                vim.notify("Swap failed: lost marks", vim.log.levels.ERROR)
            end

            vim.api.nvim_buf_del_extmark(swap_state.bufnr, ns_id, swap_state.ext1)
            vim.api.nvim_buf_del_extmark(swap_state.bufnr, ns_id, swap_state.ext2)
            swap_state = nil
        end

        vim.fn.setreg('z', saved_z, saved_z_type)
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
