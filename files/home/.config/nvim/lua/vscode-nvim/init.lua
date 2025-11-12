local vscode = require('vscode')

require "core.options"
require "core.keymaps"

vim.opt.cmdheight = 2

local keymap = vim.keymap
local set = keymap.set

-- fold
set('n', 'zc', function()
  vscode.action("editor.fold")
end)
set('n', 'zC', function()
  vscode.action("editor.foldRecursively")
end)
set('n', 'zM', function()
  vscode.action("editor.foldAll")
end)
set('n', 'zo', function()
  vscode.action("editor.unfold")
end)
set('n', 'zO', function()
  vscode.action("editor.unfoldRecursively")
end)
set('n', 'zR', function()
  vscode.action("editor.unfoldAll")
end)
set('n', 'za', function()
  vscode.action("editor.toggleFold")
end)

-- tree
set('n', '<LEADER>e', function()
  vscode.action("workbench.action.toggleSidebarVisibility")
end)
