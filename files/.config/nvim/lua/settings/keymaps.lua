local keymap = vim.keymap

vim.g.mapleader = " "
vim.g.maplocalleader = " "

keymap.set('n', '<UP>',    '<NOP>')
keymap.set('n', '<DOWN>',  '<NOP>')
keymap.set('n', '<LEFT>',  '<NOP>')
keymap.set('n', '<RIGHT>', '<NOP>')

keymap.set('n', '<ESC><ESC>', '<CMD>noh<CR>')
