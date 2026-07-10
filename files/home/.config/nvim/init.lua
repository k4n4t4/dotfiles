vim.loader.enable()

-- require "utils.startup_time".setup { show = true }
-- require "utils.disable_plugins".setup()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    -- require "plugins"
end

vim.opt.shell = "fish"
pcall(vim.cmd.colorscheme, "solarized-osaka")
require("utils.transparent").enable()
vim.opt.number = true
vim.opt.relativenumber = false
require("utils.toggle_relnumber").enable()
vim.opt.mouse = "a"
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
