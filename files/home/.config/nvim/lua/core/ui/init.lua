local plugin = require "utils.plugin"
plugin.load("nvim-web-devicons", "User", "Ready")

local hi = require "utils.highlight"

hi.link("MacroRecord", "Operator")
hi.link("FileModified", "WarningMsg")
hi.link("GitBranch", "Constant")

require "core.ui.statusline"
require "core.ui.statuscolumn"
require "core.ui.tabline"
require "core.ui.foldtext"
require "core.ui.terminal"
