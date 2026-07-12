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
    statusline = function()
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

        return stl.make_str {
            "[",
            {
                hl = mode.hl,
                content = {
                    mode.content,
                }
            },
            "]",
            lsp and {
                content = {
                    "[",
                    {
                        hl = "Number",
                        click = lsp.click,
                        content = {
                            lsp.content,
                        },
                    },
                    "]",
                },
            } or {},
            git and {
                content = {
                    "[",
                    {
                        content = git
                    },
                    "]",
                },
            } or {},
            diagnostic and {
                content = {
                    "[",
                    {
                        content = diagnostic,
                    },
                    "]",
                },
            } or {},
            (encoding and encoding ~= "") and {
                content = {
                    "[",
                    {
                        content = encoding,
                    },
                    "]",
                },
            } or {},
            fileformat and {
                content = {
                    "[",
                    {
                        content = (fileformat.icon or "") .. (fileformat.label or ""),
                    },
                    "]",
                },
            } or {},
            macro and {
                content = {
                    "[",
                    {
                        hl = macro.hl,
                        content = macro.content,
                    },
                    "]",
                },
            } or {},
            search_count and {
                content = {
                    "[",
                    search_count,
                    "]",
                },
            } or "",
            file and {
                content = {
                    "[",
                    filetype and {
                        hl = filetype.hl,
                        content = filetype.content,
                    } or {},
                    file,
                    flags and {
                        hl = flags.hl,
                        content = flags.content,
                    } or {},
                    "]",
                },
            } or "",
        }
    end,
}
