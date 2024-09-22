function TabLine()
  local tabline = ""
  for i = 1, vim.fn.tabpagenr('$') do
    local id = "%" .. tostring(i) .. "T"
    local is_current = i == vim.fn.tabpagenr()
    local window_number = vim.fn.tabpagewinnr(i)
    local buf_list = vim.fn.tabpagebuflist(i)
    local buf_name = vim.fn.bufname(buf_list[window_number])
    local buf_count = #buf_list
    local file_name = vim.fn.fnamemodify(buf_name, ":t")

    local label = ""

    local highlight
    if is_current then
      highlight = "%#TabLineSel#"
    else
      highlight = "%#TabLine#"
    end

    label = label .. id

    if file_name == "" then
      label = label .. "[EMPTY]"
    else
      label = label .. file_name
    end

    if not is_current and buf_count ~= 1 then
      label = label .. "(" .. buf_count .. ")"
    end

    tabline = tabline .. highlight .. " " .. label .. " "
  end
  return tabline .. "%#TabLineFill#%T"
end


vim.opt.tabline = "%!v:lua.TabLine()"
