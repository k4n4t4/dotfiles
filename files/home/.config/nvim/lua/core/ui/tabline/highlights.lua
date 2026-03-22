local hl = require("utils.highlight")

hl.set("TabLine", {
    fg = hl.ref("TabLine", "fg"),
    bg = hl.ref("Normal", "bg"),
})
hl.set("TabLineSel", {
    fg = hl.ref("TabLineSel", "fg"),
    bg = hl.ref("Normal", "bg"),
    bold = true,
})
hl.set("TabLineFill", {
    fg = hl.ref("LineNr", "fg"),
    bg = hl.ref("NormalNC", "bg"),
})
