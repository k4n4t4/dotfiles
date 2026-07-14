local set = vim.keymap.set

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
