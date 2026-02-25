local hi = require("utils.highlight")

hi.set("StlModeNormal", { fg = "#99EE99" })
hi.set("StlModeInsert", { fg = "#EE9999" })
hi.set("StlModeReplace", { fg = "#EEEE99" })
hi.set("StlModeVisual", { fg = "#9999EE" })
hi.set("StlModeConfirm", { fg = "#999999" })
hi.set("StlModeTerminal", { fg = "#999999" })
hi.set("StlModeOther", { fg = "#EE99EE" })

hi.set("StlMacro", { fg = hi.ref("MacroRecord", 'fg') })

hi.set("StlFileFlag", { fg = hi.ref("FileModified", 'fg') })

hi.set("StlDiagnosticERROR", { fg = hi.ref("DiagnosticError", 'fg') })
hi.set("StlDiagnosticWARN", { fg = hi.ref("DiagnosticWarn", 'fg') })
hi.set("StlDiagnosticINFO", { fg = hi.ref("DiagnosticInfo", 'fg') })
hi.set("StlDiagnosticHINT", { fg = hi.ref("DiagnosticHint", 'fg') })

hi.set("StlGitAdd", { fg = hi.ref("GitSignsAdd", 'fg') })
hi.set("StlGitRemove", { fg = hi.ref("GitSignsDelete", 'fg') })
hi.set("StlGitChange", { fg = hi.ref("GitSignsChange", 'fg') })
hi.set("StlGitBranch", { fg = hi.ref("GitBranch", "fg") })
hi.set("StlSep", { fg = hi.ref("WinSeparator", "fg") })
