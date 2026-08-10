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
    local vs = require('utils.visual-swap')
    local pending = nil
    local hl_ns = vim.api.nvim_create_namespace("VisualSwapPending")

    vim.api.nvim_set_hl(0, "VisualSwapPendingHighlight", { link = "IncSearch" })

    local function handle_selection(bufnr, range)
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

        vs.swap(pending.bufnr, pending.range, bufnr, range)
        vim.api.nvim_buf_del_extmark(pending.bufnr, hl_ns, pending.extmark_id)
        pending = nil
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    _G.visual_swap_opfunc = function(motion_type)
        local s = vim.api.nvim_buf_get_mark(0, '[')
        local e = vim.api.nvim_buf_get_mark(0, ']')
        local s_row, s_col = s[1] - 1, s[2]
        local e_row, e_col = e[1] - 1, e[2]
        local bufnr = vim.api.nvim_get_current_buf()

        if motion_type == "line" then
            s_col = 0
            local line = vim.api.nvim_buf_get_lines(bufnr, e_row, e_row + 1, false)[1] or ""
            e_col = #line
        else
            local line = vim.api.nvim_buf_get_lines(bufnr, e_row, e_row + 1, false)[1] or ""
            local ok, char = pcall(vim.fn.strpart, line, e_col, 1, true)
            if ok and char ~= "" then
                e_col = e_col + #char
            else
                e_col = math.min(e_col + 1, #line)
            end
        end

        if s_row > e_row or (s_row == e_row and s_col > e_col) then
            s_row, s_col, e_row, e_col = e_row, e_col, s_row, s_col
        end

        handle_selection(bufnr, { s_row, s_col, e_row, e_col })
    end

    vim.keymap.set('n', '<leader>s', function()
        vim.go.operatorfunc = 'v:lua.visual_swap_opfunc'
        return 'g@'
    end, { expr = true, desc = "Swap text object" })

    vim.keymap.set('n', '<leader>ss', function()
        vim.go.operatorfunc = 'v:lua.visual_swap_opfunc'
        return 'g@_'
    end, { expr = true, desc = "Swap line" })

    vim.keymap.set('x', '<leader>s', function()
        local bufnr = vim.api.nvim_get_current_buf()
        local range = vs.visual_range(bufnr)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
        handle_selection(bufnr, range)
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
