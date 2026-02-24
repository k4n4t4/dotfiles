local hi = require("utils.highlight")

hi.set("StlModeNormal", { fg = "#99EE99" })
hi.set("StlModeInsert", { fg = "#EE9999" })
hi.set("StlModeReplace", { fg = "#EEEE99" })
hi.set("StlModeVisual", { fg = "#9999EE" })
hi.set("StlModeConfirm", { fg = "#999999" })
hi.set("StlModeTerminal", { fg = "#999999" })
hi.set("StlModeOther", { fg = "#EE99EE" })

hi.set("StlMacro", { fg = "#BB77EE" })

hi.set("StlFileFlag", { fg = hi.get("FileModified").fg })

hi.set("StlDiagnosticERROR", { fg = hi.get("DiagnosticError").fg })
hi.set("StlDiagnosticWARN", { fg = hi.get("DiagnosticWarn").fg })
hi.set("StlDiagnosticINFO", { fg = hi.get("DiagnosticInfo").fg })
hi.set("StlDiagnosticHINT", { fg = hi.get("DiagnosticHint").fg })

hi.set("StlGitAdd", { fg = hi.get("GitSignsAdd").fg })
hi.set("StlGitRemove", { fg = hi.get("GitSignsDelete").fg })
hi.set("StlGitChange", { fg = hi.get("GitSignsChange").fg })
hi.set("StlGitBranch", { fg = "#CC9955" })


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
