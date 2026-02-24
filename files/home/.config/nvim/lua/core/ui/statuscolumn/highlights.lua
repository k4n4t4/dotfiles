local hl = require("utils.highlight")

-- FoldColumn: fold head markers (> / v); NonText: fold body lines (¦)
hl.link("StatusColumnFoldHead", "FoldColumn")
hl.link("StatusColumnFold", "NonText")
