local keymap = vim.keymap
local set = keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "


set("n", "<ESC><ESC>", "<CMD>noh<CR>")
set("t", "<ESC>", "<C-\\><C-N>")

set("n", "<LEADER>c", "<CMD>belowright new<CR><CMD>terminal<CR>")
set("n", "<LEADER>C", "<CMD>terminal<CR>")

set("n", "<LEADER>h", "viwo<CMD>let @/=getregion(getpos('v'), getpos('.'))[0]<CR><CMD>set hls<CR><ESC>")
set("x", "<LEADER>h", "<CMD>let @/=getregion(getpos('v'), getpos('.'), {'type': mode()})[0]<CR><CMD>set hls<CR><ESC><CMD>call setpos('.', getpos(\"'<\"))<CR>")

set("x", "<LEADER>s", ":<C-u>%s/<C-r>=getregion(getpos(\"\'<\"), getpos(\"\'>\"))[0]<CR>//g<LEFT><LEFT>")
