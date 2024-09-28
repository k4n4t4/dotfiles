vim.g.jetpack_download_method = 'curl'

local jetpackfile = vim.fn.stdpath('data') .. '/site/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
if vim.fn.filereadable(jetpackfile) == 0 then
  vim.fn.system(
    'curl -fsSLo ' ..
    jetpackfile ..
    ' --create-dirs ' ..
    'https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim'
  )
end

vim.cmd [[ packadd vim-jetpack ]]
require('jetpack.packer').add {
  { 'tani/vim-jetpack' },
  { 'dstein64/vim-startuptime' },
}
