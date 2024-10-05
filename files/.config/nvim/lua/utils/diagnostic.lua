local M = {}

M.SEVERITY = vim.diagnostic.severity

---@param bufnr number
---@param severity_list? vim.diagnostic.Severity[]
---@return table<vim.diagnostic.Severity, vim.Diagnostic[]>
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
