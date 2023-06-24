require'bufferline'.setup {
}
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<C-j>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-k>', '<Cmd>BufferNext<CR>', opts)
-- Close buffer
map('n', '<leader>e', '<Cmd>BufferClose<CR>', opts)

