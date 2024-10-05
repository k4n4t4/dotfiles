local M = {}

---@param fmt string
---@param ... any
function M.log(fmt, ...)
  print(string.format(fmt, ...))
end

return M
