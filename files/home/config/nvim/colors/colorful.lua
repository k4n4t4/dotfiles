local use_cterm, palette

if vim.o.background == "dark" then
    palette = {
        base00 = "#202020",
        base01 = "#272727",
        base02 = "#2F2F2F",
        base03 = "#606060",
        base04 = "#676767",
        base05 = "#A0A0A0",
        base06 = "#B0B0B0",
        base07 = "#C0C0C0",
        base08 = "#C05050",
        base09 = "#C07050",
        base0A = "#C09000",
        base0B = "#70C070",
        base0C = "#50C0C0",
        base0D = "#5090C0",
        base0E = "#C090C0",
        base0F = "#D0D0D0",
    }
    use_cterm = true
end

if palette then
    require("mini.base16").setup({ palette = palette, use_cterm = use_cterm })
    vim.g.colors_name = "colorful"
end
