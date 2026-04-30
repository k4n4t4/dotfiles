return {
    'stevearc/oil.nvim',
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    event = 'User DirEnter',
    config = function()
        require('oil').setup {
        }
    end,
    keys = {
        { '<Leader>-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
    },
}
