local hl = require("utils.highlight")

hl.set("TabLine", {
    fg = hl.ref("TabLine", "fg"),
    bg = hl.ref("TabLine", "bg"),
})
hl.set("TabLineSel", {
    fg = hl.ref("TabLineSel", "fg"),
    bg = hl.ref("StatusLine", "bg"),
    bold = true,
})
hl.set("TabLineFill", {
    fg = hl.ref("TabLineFill", "fg"),
    bg = hl.ref("TabLineFill", "bg"),
})
