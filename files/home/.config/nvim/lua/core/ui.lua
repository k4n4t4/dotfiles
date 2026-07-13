-- vim.pack.add {
--     "https://github.com/k4n4t4/statusline.nvim",
-- }

--[[ STATUSLINE ]]--
vim.opt.cmdheight = 0
vim.opt.laststatus = 3
local stl = require "utils.statusline"

stl.setup {
    statusline = function(ctx)
        local mode = stl.mode { align = "center" }
        local lsp = stl.lsp { show = false }
        local git = stl.git()
        local diagnostic = stl.diagnostic()
        local encoding = stl.encoding()
        local fileformat = stl.fileformat()
        local macro = stl.macro_recording()
        local search_count = stl.search_count()
        local file = stl.file()
        local flags = stl.flags()
        local filetype = stl.filetype { icon_provider = "nvim-web-devicons" }

        local sep = "%#Comment#│%*"

        if ctx.active then
            return stl.make_str {
                {
                    hl = mode.hl,
                    content = mode.content,
                },
                " ", sep, " ",
                macro and {
                    hl = macro.hl,
                    content = macro.content,
                } or "",
                " ",
                file or "",
                flags and {
                    hl = flags.hl,
                    content = flags.content,
                } or "",
                " ",
                git and {
                    content = git,
                } or "",
                " ",
                diagnostic and {
                    content = diagnostic,
                } or "",
                "%=%<",
                "%S ",
                search_count or "",
                lsp and {
                    hl = "Number",
                    click = lsp.click,
                    content = lsp.content,
                } or "",
                " ",
                filetype or "",
                " ", sep, " ",
                encoding or "",
                " ",
                fileformat and ((fileformat.icon or "") .. (fileformat.label or "")) or "",
                " ", sep, " ",
                "%l:%c|%P",
            }
        else
            return stl.make_str {
                {
                    hl = mode.hl,
                    content = mode.content,
                },
                " ",
                file or "",
                flags and {
                    hl = flags.hl,
                    content = flags.content,
                } or "",
                "%=%<",
                filetype and {
                    hl = filetype.hl,
                    content = filetype.content,
                } or "",
                " ", sep, " ",
                "%l:%c  %P",
            }
        end
    end,
}


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
