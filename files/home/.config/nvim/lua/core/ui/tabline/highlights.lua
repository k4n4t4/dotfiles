local highlights = require("utils.highlight")

local function tabline_highlights()
    highlights.set("TabLine", {
        fg = "none",
        bg = "#202020",
    })
    highlights.set("TabLineFill", {
        fg = "none",
        bg = "#111111",
    })
    highlights.set("TabLineSel", {
        fg = "#A0A0A0",
        bg = "#202020",
    })
    highlights.set("TabLineSelUntitled", {
        fg = "#707070",
        bg = "#202020",
        italic = true,
    })
    highlights.set("TabLineActive", {
        fg = "none",
        bg = "#404040",
    })
    highlights.set("TabLineActiveFileName", {
        fg = "#E0E0E0",
        bg = "#404040",
    })
    highlights.set("TabLineActiveUntitled", {
        fg = "#909090",
        bg = "#404040",
        italic = true,
    })
end

tabline_highlights()
