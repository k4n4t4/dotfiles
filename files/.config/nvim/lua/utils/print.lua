local M = {}

---@param list [string, string][]
function M.echo(list)
  vim.api.nvim_echo(list, true, {})
end

---@param fmt string
---@param ... any
function M.log(fmt, ...)
  M.echo { { string.format(fmt, ...), "None" } }
end

---@param fmt string
---@param ... any
function M.warn(fmt, ...)
  M.echo { { string.format(fmt, ...), "WarningMsg" } }
end

---@param fmt string
---@param ... any
function M.error(fmt, ...)
  M.echo { { string.format(fmt, ...), "ErrorMsg" } }
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
  return string.gsub(str, "[\\" .. quote .. "]", function(s)
    if s == "\\" then
      return "\\\\"
    elseif s == quote then
      return "\\" .. quote
    end
  end)
end

local function table_to_str(tbl, indent_count, ignore_tables)
  indent_count = indent_count or 0
  ignore_tables = ignore_tables or { _G }
  local indent = string.rep("  ", indent_count)
  local str = "{\n"
  for k, v in pairs(tbl) do
    local key = tostring(k)
    if type(v) == 'table' then
      if table_contains(ignore_tables, v) then
        local value = tostring(v)
        str = str .. indent .. "  " .. key .. " = " .. value .. ",\n"
      else
        local value = table_to_str(v, indent_count + 1, ignore_tables)
        table.insert(ignore_tables, v)
        str = str .. indent .. "  " .. key .. " = " .. value .. ",\n"
      end
    else
      local value
      if type(v) == 'string' then
        local quote = '"'
        value = quote .. string_escape_quote(v, quote) .. quote
      else
        value = tostring(v)
      end
      str = str .. indent .. "  " .. key .. " = " .. value .. ",\n"
    end
  end
  return str .. indent .. "}"
end

---@param tbl table<any>
function M.table(tbl)
  M.echo { { table_to_str(tbl), "None" } }
end

M.table(_G)

return M
