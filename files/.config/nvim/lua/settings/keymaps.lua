local keymap = vim.keymap
local set = keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "


set("t", "<ESC>", "<C-\\><C-N>")

set("n", "<LEADER>c", "<CMD>belowright 10split<CR><CMD>terminal<CR>")
set("n", "<LEADER>C", "<CMD>terminal<CR>")

function TerminalOpenFile(file, pwd)
  local empty = file == ""
  file = vim.fn.fnamemodify(file, ':p')
  vim.cmd.tabedit(file .. (empty and "Untitled" or ""))
end

set("n", "<LEADER>H", "<CMD>noh<CR>")
set("n", "<LEADER>h", "viwo<CMD>let @/=getregion(getpos('v'), getpos('.'))[0]<CR><CMD>set hls<CR><ESC>")
set("x", "<LEADER>h", "<CMD>let @/=getregion(getpos('v'), getpos('.'), {'type': mode()})[0]<CR><CMD>set hls<CR><ESC><CMD>call setpos('.', getpos(\"'<\"))<CR>")

set("n", "<LEADER>s", "viw:<C-u>%s/<C-r>=getregion(getpos(\"\'<\"), getpos(\"\'>\"))[0]<CR>//g<LEFT><LEFT>")
set("x", "<LEADER>s", ":<C-u>%s/<C-r>=getregion(getpos(\"\'<\"), getpos(\"\'>\"))[0]<CR>//g<LEFT><LEFT>")
