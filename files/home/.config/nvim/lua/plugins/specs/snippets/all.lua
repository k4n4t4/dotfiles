local ls = require "luasnip"

local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

return {
  s("todo", {
    t("TODO: "), i(1), t(" ("), f(function() return os.date("%Y-%m-%d") end), t(")")
  }),
}
