local highlight = require("utils.highlight")

highlight.set("TabLine", {
    fg = "none",
    bg = "#202020",
})
highlight.set("TabLineFill", {
    fg = "none",
    bg = "#111111",
})
highlight.set("TabLineSel", {
    fg = "#A0A0A0",
    bg = "#202020",
})
highlight.set("TabLineSelUntitled", {
    fg = "#707070",
    bg = "#202020",
    italic = true,
})
highlight.set("TabLineActive", {
    fg = "none",
    bg = "#404040",
})
highlight.set("TabLineActiveFileName", {
    fg = "#E0E0E0",
    bg = "#404040",
})
highlight.set("TabLineActiveUntitled", {
    fg = "#909090",
    bg = "#404040",
    italic = true,
})
