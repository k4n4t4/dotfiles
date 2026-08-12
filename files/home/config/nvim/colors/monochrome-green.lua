local use_cterm, palette

if vim.o.background == "dark" then
    palette = {
        base00 = "#001100",
        base01 = "#002200",
        base02 = "#003300",
        base03 = "#004400",
        base04 = "#006600",
        base05 = "#008800",
        base06 = "#00aa00",
        base07 = "#00cc00",
        base08 = "#007700",
        base09 = "#008800",
        base0A = "#009900",
        base0B = "#00aa00",
        base0C = "#00bb00",
        base0D = "#00cc00",
        base0E = "#00dd00",
        base0F = "#00ee00",
    }
    use_cterm = true
end

if vim.o.background == "light" then
    palette = {
        base00 = "#00ee00",
        base01 = "#00dd00",
        base02 = "#00cc00",
        base03 = "#00bb00",
        base04 = "#009900",
        base05 = "#007700",
        base06 = "#005500",
        base07 = "#003300",
        base08 = "#008800",
        base09 = "#007700",
        base0A = "#006600",
        base0B = "#005500",
        base0C = "#004400",
        base0D = "#003300",
        base0E = "#002200",
        base0F = "#001100",
    }
    use_cterm = true
end

if palette then
    require("mini.base16").setup({ palette = palette, use_cterm = use_cterm })
    vim.g.colors_name = "monochrome-green"
end
