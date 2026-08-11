local use_cterm, palette

if vim.o.background == "dark" then
    palette = {
        base00 = "#111111",
        base01 = "#222222",
        base02 = "#333333",
        base03 = "#444444",
        base04 = "#666666",
        base05 = "#888888",
        base06 = "#aaaaaa",
        base07 = "#cccccc",
        base08 = "#777777",
        base09 = "#888888",
        base0A = "#999999",
        base0B = "#aaaaaa",
        base0C = "#bbbbbb",
        base0D = "#cccccc",
        base0E = "#dddddd",
        base0F = "#eeeeee",
    }
    use_cterm = true
end

if vim.o.background == "light" then
    palette = {
        base00 = "#eeeeee",
        base01 = "#dddddd",
        base02 = "#cccccc",
        base03 = "#bbbbbb",
        base04 = "#999999",
        base05 = "#777777",
        base06 = "#555555",
        base07 = "#333333",
        base08 = "#888888",
        base09 = "#777777",
        base0A = "#666666",
        base0B = "#555555",
        base0C = "#444444",
        base0D = "#333333",
        base0E = "#222222",
        base0F = "#111111",
    }
    use_cterm = true
end

if palette then
    require("mini.base16").setup({ palette = palette, use_cterm = use_cterm })
    vim.g.colors_name = "monochrome"
end
