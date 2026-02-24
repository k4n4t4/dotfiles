local hi = require("utils.highlight")
local utils_diagnostic = require("utils.diagnostic")

local diagnostic_props = {
    ERROR = { icon = "!", hi = "StlDiagnosticERROR" },
    WARN  = { icon = "*", hi = "StlDiagnosticWARN" },
    INFO  = { icon = "i", hi = "StlDiagnosticINFO" },
    HINT  = { icon = "?", hi = "StlDiagnosticHINT" },
}

return function()
    local format = {}
    local diagnoses = utils_diagnostic.get(0)
    for k, v in pairs(diagnoses) do
        if #v ~= 0 then
            local name = vim.diagnostic.severity[k]
            local prop = diagnostic_props[name]
            table.insert(format, hi.use(prop.hi) .. prop.icon .. #v .. "%*")
        end
    end
    return table.concat(format, "")
end
