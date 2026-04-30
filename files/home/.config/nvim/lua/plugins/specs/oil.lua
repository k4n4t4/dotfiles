return {
    'stevearc/oil.nvim',
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    event = 'User DirEnter',
    config = function()
        require('oil').setup {
        }
    end,
    keys = {
        { mode = 'n', '<Leader>-', '<CMD>Oil<CR>', desc = 'Open parent directory' },
        { mode = 'n', '<Leader>=', '<CMD>Oil --float<CR>', desc = 'Open parent directory' },
    },
}
