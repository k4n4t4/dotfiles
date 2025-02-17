local keymap = vim.keymap
local set = keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

--netrw
if not vim.g.loaded_netrw then
  vim.keymap.set("n", "<LEADER>e", "<CMD>Lexplore<CR>")
end

-- plugin
set('n', '<LEADER>p', "<CMD>Lazy<CR>")


-- terminal
set('t', '<ESC>', "<C-\\><C-N>")
set('n', '<LEADER>c', "<CMD>belowright 10split<CR><CMD>terminal<CR>", { desc = "Terminal" })
set('n', '<LEADER>C', "<CMD>terminal<CR>", { desc = "Terminal (full)" })


-- highlight, replace
set('n', '<LEADER>H', "<CMD>noh<CR>", { desc = "nohlsearch" })
set('n', '<LEADER>h', "viwo<CMD>let @/=getregion(getpos('v'), getpos('.'))[0]<CR><CMD>set hls<CR><ESC>",
  { desc = "Highlight" })
set('x', '<LEADER>h',
  "<CMD>let @/='\\V'..escape(getregion(getpos('v'), getpos('.'), {'type': mode()})[0], '/\\')<CR><CMD>set hls<CR><ESC><CMD>call setpos('.', getpos(\"'<\"))<CR>",
  { desc = "Highlight" })

set('n', '<LEADER>s', "viw:<C-u>%s/<C-r>=getregion(getpos(\"\'<\"), getpos(\"\'>\"))[0]<CR>//g<LEFT><LEFT>",
  { desc = "Replace" })
set('x', '<LEADER>s',
  ":<C-u>%s/\\V<C-r>=escape(getregion(getpos(\"\'<\"), getpos(\"\'>\"))[0], '/\\')<CR>//g<LEFT><LEFT>",
  { desc = "Replace" })


-- lsp
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    set('n', '<LEADER>lf', vim.lsp.buf.format, { desc = "Format" })
    set('n', '<LEADER>lr', vim.lsp.buf.rename, { desc = "Rename" })
    set('n', '<LEADER>ld', vim.lsp.buf.definition, { desc = "Definition" })
    set('n', '<LEADER>lt', vim.lsp.buf.type_definition, { desc = "Type Definition" })
    set('n', '<LEADER>lh', vim.lsp.buf.hover, { desc = "Hover" })
    set('n', '<LEADER>lc', vim.lsp.buf.code_action, { desc = "Code Action" })
    set('n', '<LEADER>lg', vim.lsp.buf.references, { desc = "References" })
    set('n', '<LEADER>ls', vim.lsp.buf.signature_help, { desc = "Signature Help" })
    set('n', '<LEADER>le', function() vim.lsp.diagnostic.show_line_diagnostics() end, { desc = "Show Line Diagnostics" })
    set('n', '<LEADER>l[', function() vim.lsp.diagnostic.goto_prev() end, { desc = "Diagnostic Goto Prev" })
    set('n', '<LEADER>l]', function() vim.lsp.diagnostic.goto_next() end, { desc = "Diagnostic Goto Next" })
  end,
})


set('n', '<TAB>', "5j")
set('n', '<S-TAB>', "5k")
set('x', '<TAB>', "5j")
set('x', '<S-TAB>', "5k")

set('i', '<S-CR>', "<C-O>O")
set('i', '<S-TAB>', "<C-O><<")
