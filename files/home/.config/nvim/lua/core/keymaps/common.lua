local keymap = vim.keymap
local set = keymap.set


-- move
set({ 'n', 'o', 'x' }, '<tab>', "5j", { desc = "Scroll Down" })
set({ 'n', 'o', 'x' }, '<S-tab>', "5k", { desc = "Scroll Up" })

set({ 'n', 'x' }, '<leader>w', "<C-w><C-w>", { desc = "Switch Window" })

set('n', '<leader>H', "<cmd>noh<cr>", { desc = "No hlsearch" })

set({ 'n', 'x' }, '<leader>a', "ggVoG", { desc = "Select All" })

set('n', '<M-j>', require"utils.tabuf".next, { desc = "Tabuf Next" })
set('n', '<M-k>', require"utils.tabuf".prev, { desc = "Tabuf Prev" })
set('n', '<M-x>', require"utils.tabuf".close, { desc = "Tabuf Close" })
set('n', '<leader>mh', vim.cmd.tabprevious, { desc = "Tab Left" })
set('n', '<leader>ml', vim.cmd.tabnext, { desc = "Tab Right" })
