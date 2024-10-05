local M = {}

---@param fmt string
---@param ... any
function M.log(fmt, ...)
  vim.api.nvim_echo({
    {string.format(fmt, ...), "None"}
  }, true, {})
end

---@param fmt string
---@param ... any
function M.error(fmt, ...)
  vim.api.nvim_echo({
    {string.format(fmt, ...), "ErrorMsg"}
  }, true, {})
end

---@param fmt string
---@param ... any
function M.warn(fmt, ...)
  vim.api.nvim_echo({
    {string.format(fmt, ...), "WarningMsg"}
  }, true, {})
end


local function table_contains(tbl, elm)
  for _, v in pairs(tbl) do
    if v == elm then
      return true
    end
  end
  return false
end

local function string_escape_quote(str, quote)
  quote = quote or '"'
  return string.gsub(str, "[\\"..quote.."]", function(s)
    if s == "\\" then
      return "\\\\"
    elseif s == quote then
      return "\\"..quote
    end
  end)
end

local function table_to_str(tbl, indent, ignore_tables)
  indent = indent or 0
  ignore_tables = ignore_tables or {_G}
  local str = "{\n"
  for k, v in pairs(tbl) do
    if type(v) == 'table' then
      if table_contains(ignore_tables, v) then
        str = str .. string.rep("  ", indent + 1) .. tostring(k) .. " = " .. tostring(v) .. ",\n"
      else
        table.insert(ignore_tables, v)
        str = str .. string.rep("  ", indent + 1) .. tostring(k) .. " = " .. table_to_str(v, indent + 1, ignore_tables) .. ",\n"
      end
    else
      local fmt
      if type(v) == 'string' then
        local quote = '"'
        fmt = quote .. string_escape_quote(v, quote) .. quote
      else
        fmt = tostring(v)
      end
      str = str .. string.rep("  ", indent + 1) .. tostring(k) .. " = " .. fmt .. ",\n"
    end
  end
  return str .. string.rep("  ", indent) .. "}"
end

---@param tbl table<any>
function M.table(tbl)
  vim.api.nvim_echo({
    {table_to_str(tbl), "None"}
  }, true, {})
end


return M
