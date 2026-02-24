local hi = require("utils.highlight")

hi.set("StlModeNormal", { fg = "#99EE99" })
hi.set("StlModeInsert", { fg = "#EE9999" })
hi.set("StlModeReplace", { fg = "#EEEE99" })
hi.set("StlModeVisual", { fg = "#9999EE" })
hi.set("StlModeConfirm", { fg = "#999999" })
hi.set("StlModeTerminal", { fg = "#999999" })
hi.set("StlModeOther", { fg = "#EE99EE" })

hi.set("StlMacro", { fg = hi.ref("MacroRecord", 'fg') })

hi.set("StlFileFlag", { fg = hi.ref("FileModified", 'fg') })

hi.set("StlDiagnosticERROR", { fg = hi.ref("DiagnosticError", 'fg') })
hi.set("StlDiagnosticWARN", { fg = hi.ref("DiagnosticWarn", 'fg') })
hi.set("StlDiagnosticINFO", { fg = hi.ref("DiagnosticInfo", 'fg') })
hi.set("StlDiagnosticHINT", { fg = hi.ref("DiagnosticHint", 'fg') })

hi.set("StlGitAdd", { fg = hi.ref("GitSignsAdd", 'fg') })
hi.set("StlGitRemove", { fg = hi.ref("GitSignsDelete", 'fg') })
hi.set("StlGitChange", { fg = hi.ref("GitSignsChange", 'fg') })
hi.set("StlGitBranch", { fg = hi.ref("GitBranch", "fg") })


local group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

-- Redraw statusline when mode changed. (e.g. 'ix' mode)
vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function()
        local ignore_ft = {
            "TelescopePrompt",
            "NvimTree",
            "neo-tree",
            "fzf",
        }
        local ignore_bt = {
            "terminal",
            "nofile",
            "prompt",
        }

        if vim.tbl_contains(ignore_ft, vim.bo.filetype) or
            vim.tbl_contains(ignore_bt, vim.bo.buftype) then
            return
        end

        vim.cmd.redrawstatus()
    end,
})
