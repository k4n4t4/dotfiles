local utils_diagnostic = require("utils.diagnostic")
local mapping        = require("utils.mapping")

local severity_hi = {
    ERROR = "StlDiagnosticERROR",
    WARN  = "StlDiagnosticWARN",
    INFO  = "StlDiagnosticINFO",
    HINT  = "StlDiagnosticHINT",
}

return function()
    local format = {}
    local diagnoses = utils_diagnostic.get(0)
    for k, v in pairs(diagnoses) do
        if #v ~= 0 then
            local name = vim.diagnostic.severity[k]
            local sev  = mapping.severity.get(name)
            local hl   = severity_hi[name] or severity_hi.ERROR
            table.insert(format, "%#"..hl.."#" .. sev.icon .. #v .. "%*")
        end
    end
    return table.concat(format, "")
end
