local keymap = vim.keymap
local set = keymap.set


-- terminal
set('t', '<ESC>', "<C-\\><C-N>")
set('n', '<LEADER>k', "<CMD>belowright 10split<CR><CMD>terminal<CR>", { desc = "Terminal" })
set('n', '<LEADER>K', "<CMD>terminal<CR>", { desc = "Terminal (full)" })


-- highlight, replace
set('n', '<LEADER>H', "<CMD>noh<CR>", { desc = "nohlsearch" })
set('n', '<LEADER>h', "viwo<CMD>let @/=getregion(getpos('v'), getpos('.'))[0]<CR><CMD>set hls<CR><ESC>",
    { desc = "Highlight" })
set('x', '<LEADER>h',
    "<CMD>let @/='\\V'..escape(getregion(getpos('v'), getpos('.'), {'type': mode()})[0], '/\\')<CR><CMD>set hls<CR><ESC><CMD>call setpos('.', getpos(\"'<\"))<CR>",
    { desc = "Highlight" })


-- move
set('n', '<TAB>', "5j",   { desc = "Scroll Down" })
set('n', '<S-TAB>', "5k", { desc = "Scroll Up" })
set('x', '<TAB>', "5j",   { desc = "Scroll Down" })
set('x', '<S-TAB>', "5k", { desc = "Scroll Up" })

set('n', '<LEADER>w', "<C-W><C-W>", { desc = "Switch Window" })
