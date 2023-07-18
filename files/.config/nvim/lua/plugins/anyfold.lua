vim.api.nvim_create_augroup( '*', {} )
vim.api.nvim_create_autocmd( 'filetype', {
  group = '*',
  callback = function() vim.cmd('AnyFoldActivate') end
})
vim.opt.foldlevel = 99
