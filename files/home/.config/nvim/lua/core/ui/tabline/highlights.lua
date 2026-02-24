local hl = require("utils.highlight")

hl.set("TabLine", {
    fg = hl.ref("LineNr", "fg"),
    bg = "#202020",
})
hl.set("TabLineSel", {
    fg = hl.ref("Normal", "fg"),
    bg = "#303030",
    bold = true,
})
hl.set("TabLineFill", {
    fg = hl.ref("LineNr", "fg"),
    bg = "#101010",
})
