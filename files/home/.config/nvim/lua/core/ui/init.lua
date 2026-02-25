local plugin = require "utils.plugin"
plugin.load("nvim-web-devicons", "User", "Ready")


vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    callback = function()
        local hl = require "utils.highlight"

        hl.link("MacroRecord", "Operator")
        hl.link("FileModified", "WarningMsg")
        hl.link("GitBranch", "Constant")

        require "core.ui.statusline"
        require "core.ui.statuscolumn"
        require "core.ui.tabline"
        require "core.ui.foldtext"
        require "core.ui.terminal"
    end,
})
