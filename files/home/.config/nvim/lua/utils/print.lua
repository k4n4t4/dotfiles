local M = {}


--- Prints a list of `{text, highlight_group}` pairs using `nvim_echo`.
---@param list [string, string][]
function M.echo(list)
    vim.api.nvim_echo(list, true, {})
end

--- Prints a formatted message with no special highlight (Normal).
---@param fmt string Format string (same as string.format)
---@param ... any Arguments for the format string
function M.log(fmt, ...)
    M.echo { { string.format(fmt, ...), "None" } }
end

--- Prints a formatted warning message using the WarningMsg highlight.
---@param fmt string Format string (same as string.format)
---@param ... any Arguments for the format string
function M.warn(fmt, ...)
    M.echo { { string.format(fmt, ...), "WarningMsg" } }
end

--- Prints a formatted error message using the ErrorMsg highlight.
---@param fmt string Format string (same as string.format)
---@param ... any Arguments for the format string
function M.error(fmt, ...)
    M.echo { { string.format(fmt, ...), "ErrorMsg" } }
end

---@param tbl table<any>
---@param elm any
local function table_contains(tbl, elm)
    for _, v in pairs(tbl) do
        if v == elm then
            return true
        end
    end
    return false
end


---@param str string
---@param quote? string
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


---@param tbl table<any>
---@param indent_count? number
---@param ignore_tables? table<any>
function M.table_to_str(tbl, indent_count, ignore_tables)
    indent_count = indent_count or 0
    ignore_tables = ignore_tables or { _G }
    local indent = string.rep("  ", indent_count)
    local str = "{\n"
    for k, v in pairs(tbl) do
        local value
        local key = tostring(k)
        if type(v) == 'table' then
            if table_contains(ignore_tables, v) then
                value = tostring(v)
            else
                table.insert(ignore_tables, v)
                value = M.table_to_str(v, indent_count + 1, ignore_tables)
            end
        else
            if type(v) == 'string' then
                local quote = '"'
                value = quote .. string_escape_quote(v, quote) .. quote
            else
                value = tostring(v)
            end
        end
        str = str .. indent .. "  " .. key .. " = " .. value .. ",\n"
    end
    return str .. indent .. "}"
end


--- Pretty-prints a table as an indented string using `nvim_echo`.
---@param tbl table<any>
function M.table(tbl)
    M.echo { { M.table_to_str(tbl), "None" } }
end

return M
