local highlight = require("utils.highlight")

highlight.set("StlModeNormal", { fg = "#99EE99" })
highlight.set("StlModeInsert", { fg = "#EE9999" })
highlight.set("StlModeReplace", { fg = "#EEEE99" })
highlight.set("StlModeVisual", { fg = "#9999EE" })
highlight.set("StlModeConfirm", { fg = "#999999" })
highlight.set("StlModeTerminal", { fg = "#999999" })
highlight.set("StlModeOther", { fg = "#EE99EE" })

highlight.set("StlMacro", { fg = "#BB77EE" })

highlight.set("StlFileFlag", { fg = "#DDEE99" })

highlight.set("StlDiagnosticERROR", { fg = "#EE9999" })
highlight.set("StlDiagnosticWARN", { fg = "#EEEE99" })
highlight.set("StlDiagnosticINFO", { fg = "#99EEEE" })
highlight.set("StlDiagnosticHINT", { fg = "#99EE99" })

highlight.set("StlGitAdd", { fg = "#55CC55" })
highlight.set("StlGitRemove", { fg = "#CC5555" })
highlight.set("StlGitChange", { fg = "#5555CC" })
highlight.set("StlGitBranch", { fg = "#CC9955" })


local group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

-- Redraw statusline when mode changed. (e.g. 'ix' mode)
vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function()
        vim.cmd.redrawstatus()
    end,
})
