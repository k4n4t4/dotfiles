local tabline_group = vim.api.nvim_create_augroup("TabLine", { clear = true })

-- Override highlights
local function tabline_highlights()
    local hls = {
        {"TabLine", {
            fg = "none";
            bg = "#202020";
        }},
        {"TabLineFill", {
            fg = "none";
            bg = "#111111";
        }},
        {"TabLineFileName", {
            fg = "#A0A0A0";
            bg = "#202020";
        }},
        {"TabLineUntitled", {
            fg = "#707070";
            bg = "#202020";
            italic = true;
        }},
        {"CurrentTabLine", {
            fg = "none";
            bg = "#404040";
        }},
        {"CurrentTabLineFileName", {
            fg = "#E0E0E0";
            bg = "#404040";
        }},
        {"CurrentTabLineUntitled", {
            fg = "#909090";
            bg = "#404040";
            italic = true;
        }},
    }
    for _, v in pairs(hls) do
        local name = v[1]
        local params = v[2]
        vim.api.nvim_set_hl(0, name, params)
    end
end
vim.api.nvim_create_autocmd({
    "VimEnter",
    "ColorScheme",
}, {
    group = tabline_group;
    callback = tabline_highlights;
})
