vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = vim.api.nvim_create_augroup("StlHighlights", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "StlModeNormal", { fg = "#99EE99" })
        vim.api.nvim_set_hl(0, "StlModeInsert", { fg = "#EE9999" })
        vim.api.nvim_set_hl(0, "StlModeReplace", { fg = "#EEEE99" })
        vim.api.nvim_set_hl(0, "StlModeVisual", { fg = "#9999EE" })
        vim.api.nvim_set_hl(0, "StlModeConfirm", { fg = "#999999" })
        vim.api.nvim_set_hl(0, "StlModeTerminal", { fg = "#999999" })
        vim.api.nvim_set_hl(0, "StlModeOther", { fg = "#EE99EE" })
    end,
})
