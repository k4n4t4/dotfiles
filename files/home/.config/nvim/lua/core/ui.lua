local plugin = require "utils.plugin"
plugin.load("nvim-web-devicons", "User", "Ready")

local hi = require "utils.highlight"

hi.link("MacroRecord", "Operator")
hi.link("FileModified", "WarningMsg")
hi.link("GitBranch", "Constant")

require("utils.statusline").setup()
require("utils.statuscolumn").setup()
require("utils.tabline").setup()
require("utils.foldtext").setup()
require("utils.terminal").setup()
