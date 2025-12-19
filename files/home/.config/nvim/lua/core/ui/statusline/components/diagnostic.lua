local diagnostic_props = {
  ERROR = {
    icon = "!";
    hi = "StlDiagnosticERROR";
  };
  WARN = {
    icon = "*";
    hi = "StlDiagnosticWARN";
  };
  INFO = {
    icon = "i";
    hi = "StlDiagnosticINFO";
  };
  HINT = {
    icon = "?";
    hi = "StlDiagnosticHINT";
  };
}

local function get_diagnoses(bufnr, severity_list)
  severity_list = severity_list or {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
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

return function()
  local format = {}
  local diagnoses = get_diagnoses(0)
  for k, v in pairs(diagnoses) do
    if #v ~= 0 then
      local name = vim.diagnostic.severity[k]
      local count = #v
      table.insert(format,
        "%#" .. diagnostic_props[name].hi .. "#" ..
        diagnostic_props[name].icon ..
        count ..
        "%*"
      )
    end
  end
  return table.concat(format, "")
end

