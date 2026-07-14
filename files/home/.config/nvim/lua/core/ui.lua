require("utils.statuscolumn").setup()
require("utils.foldtext").setup()
require("utils.terminal").setup()


--[[ TABLINE ]]--
require("utils.tabline").setup()
vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = function()
        local set = vim.keymap.set

        set('n', '<M-n>', vim.cmd.enew, { desc = "Tabuf New" })
        set('n', '<M-j>', require "utils.tabuf".next, { desc = "Tabuf Next" })
        set('n', '<M-k>', require "utils.tabuf".prev, { desc = "Tabuf Prev" })
        set('n', '<M-x>', require "utils.tabuf".close, { desc = "Tabuf Close" })
        set('n', '<M-t>', vim.cmd.tabnew, { desc = "Tabuf New" })
        set('n', '<M-h>', vim.cmd.tabprevious, { desc = "Tab Left" })
        set('n', '<M-l>', vim.cmd.tabnext, { desc = "Tab Right" })
        set('n', '<M-S-x>', vim.cmd.tabclose, { desc = "Tab Close" })
    end,
})
