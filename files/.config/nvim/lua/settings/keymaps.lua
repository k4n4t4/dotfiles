local keymap = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "


keymap.set("n", "<ESC><ESC>", "<CMD>noh<CR>")
keymap.set("t", "<ESC>", "<C-\\><C-N>")

keymap.set("n", "<LEADER>c", "<CMD>belowright new<CR><CMD>terminal<CR>")
keymap.set("n", "<LEADER>C", "<CMD>terminal<CR>")

keymap.set("n", "<LEADER>m", "<CMD>messages<CR>")


keymap.set("n", "<LEADER>s", "*N")
keymap.set("x", "<LEADER>s", "<CMD>call feedkeys(\"*N\")<CR>")
