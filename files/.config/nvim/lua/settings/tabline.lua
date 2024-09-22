function TabLine()
  local tabline = ""
  for i = 1, vim.fn.tabpagenr('$') do
    if i == vim.fn.tabpagenr() then
      tabline = tabline .. "T"
    else
      tabline = tabline .. "_"
    end
  end
  return tabline
end

vim.opt.tabline = "%!v:lua.TabLine()"
