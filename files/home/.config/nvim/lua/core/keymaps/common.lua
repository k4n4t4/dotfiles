local keymap = vim.keymap
local set = keymap.set


-- terminal
set('t', '<ESC>', "<C-\\><C-N>")
set('n', '<LEADER>k', "<CMD>belowright 10split<CR><CMD>terminal<CR>", { desc = "Terminal" })
set('n', '<LEADER>K', "<CMD>terminal<CR>", { desc = "Terminal (full)" })

-- move
set('n', '<TAB>', "5j",   { desc = "Scroll Down" })
set('n', '<S-TAB>', "5k", { desc = "Scroll Up" })
set('x', '<TAB>', "5j",   { desc = "Scroll Down" })
set('x', '<S-TAB>', "5k", { desc = "Scroll Up" })

set('n', '<LEADER>w', "<C-W><C-W>", { desc = "Switch Window" })

set('n', '<LEADER>H', "<CMD>noh<CR>", { desc = "No hlsearch" })
