local group = vim.api.nvim_create_augroup("StatusColumn", { clear = true })

-- Override highlights
local function status_column_highlights()
    local hls = {
        {"StatusColumn", {
            fg = "#EEEEEE";
            bg = "none";
        }},
        {"StatusColumnNC", {
            fg = "#AAAAAA";
            bg = "none";
        }},
        {"StatusColumnFoldHead", {
            fg = "#4466CC";
            bg = "none";
        }},
        {"StatusColumnFold", {
            fg = "#224466";
            bg = "none";
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
    group = group;
    callback = status_column_highlights;
})
