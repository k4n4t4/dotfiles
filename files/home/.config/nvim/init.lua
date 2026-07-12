vim.loader.enable()

require "utils.startup_time".setup { show = true }

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "plugins"
    require "core"
end


vim.opt.cmdheight = 0
vim.opt.laststatus = 3
local stl = require "utils.stl"

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
        local filetype = stl.filetype()

        local sep = "%#StlSep#│%*"

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
                filetype and {
                    hl = filetype.hl,
                    content = filetype.content,
                } or "",
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
