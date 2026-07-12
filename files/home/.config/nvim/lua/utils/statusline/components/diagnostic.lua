local severity_label = {
    ["ERROR"] = { icon = "!", label = "Error" },
    ["WARN"]  = { icon = "*", label = "Warn" },
    ["INFO"]  = { icon = "i", label = "Info" },
    ["HINT"]  = { icon = "?", label = "Hint" },
}

local severity_hi = {
    ERROR = "StlDiagnosticERROR",
    WARN  = "StlDiagnosticWARN",
    INFO  = "StlDiagnosticINFO",
    HINT  = "StlDiagnosticHINT",
}

return function()
    local format = {}

    local bufnr = 0
    local severity_list = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
    }
    local diagnoses = {}
    for _, severity in pairs(severity_list) do
        diagnoses[severity] = vim.diagnostic.get(
            bufnr,
            { severity = severity }
        )
    end

    for k, v in pairs(diagnoses) do
        if #v ~= 0 then
            local name = vim.diagnostic.severity[k]
            local sev  = severity_label[name]
            local hl   = severity_hi[name] or severity_hi.ERROR
            table.insert(format, "%#"..hl.."#" .. sev.icon .. #v .. "%*")
        end
    end
    return table.concat(format, "")
end
