return function()
  local format = {}

  table.insert(format, "%#StatusLineFileFlag#")
  if vim.o.previewwindow then
    table.insert(format, "p")
  end
  if vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].readonly then
    table.insert(format, "r")
  else
    if vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].modifiable then
      if vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].modified then
        table.insert(format, "+")
      end
    else
        table.insert(format, "-")
    end
  end
  table.insert(format, "%*")

  return table.concat(format, "")
end

