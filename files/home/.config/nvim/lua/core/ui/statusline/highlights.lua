local function status_line_highlights()
    local hls = {
        StlModeNormal = {
            fg = "#99EE99";
        };
        StlModeInsert = {
            fg = "#EE9999";
        };
        StlModeReplace = {
            fg = "#EEEE99";
        };
        StlModeVisual = {
            fg = "#9999EE";
        };
        StlModeConfirm = {
            fg = "#999999";
        };
        StlModeTerminal = {
            fg = "#999999";
        };
        StlModeOther = {
            fg = "#EE99EE";
        };

        StlMacro = {
            fg = "#BB77EE";
        };

        StlFileFlag = {
            fg = "#DDEE99";
        };

        StlDiagnosticERROR = {
            fg = "#EE9999";
        };
        StlDiagnosticWARN = {
            fg = "#EEEE99";
        };
        StlDiagnosticINFO = {
            fg = "#99EEEE";
        };
        StlDiagnosticHINT = {
            fg = "#99EE99";
        };

        StlGitAdd = {
            fg = "#55CC55";
        };
        StlGitRemove = {
            fg = "#CC5555";
        };
        StlGitChange = {
            fg = "#5555CC";
        };
        StlGitBranch = {
            fg = "#CC9955";
        };
    }
    for name, spec in pairs(hls) do
        vim.api.nvim_set_hl(0, name, spec)
    end
end


local group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

vim.api.nvim_create_autocmd({
    "VimEnter",
    "ColorScheme",
}, {
    group = group;
    callback = status_line_highlights;
})

-- Redraw statusline when mode changed. (e.g. 'ix' mode)
vim.api.nvim_create_autocmd("ModeChanged", {
    group = group;
    callback = function()
        vim.cmd.redrawstatus()
    end;
})
