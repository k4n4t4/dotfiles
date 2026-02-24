local M = {}

M.SEVERITY = vim.diagnostic.severity


--- Returns diagnostics for a buffer, grouped by severity.
---@param bufnr number Buffer number (0 for current buffer)
---@param severity_list? vim.diagnostic.Severity[] Severities to include; defaults to all four levels
---@return table<vim.diagnostic.Severity, vim.Diagnostic[]> Map from severity to list of diagnostics
function M.get(bufnr, severity_list)
    severity_list = severity_list or {
        M.SEVERITY.ERROR,
        M.SEVERITY.WARN,
        M.SEVERITY.INFO,
        M.SEVERITY.HINT,
    }
    local diagnoses = {}
    for _, severity in pairs(severity_list) do
        diagnoses[severity] = vim.diagnostic.get(
            bufnr,
            {
                severity = severity
            }
        )
    end
    return diagnoses
end

return M
