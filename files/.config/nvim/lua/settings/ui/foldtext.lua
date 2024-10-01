function FoldText()
  local virt_texts = {}

  local line_text = vim.fn.getline(vim.v.foldstart)
  for i = 0, #line_text-1 do
    local inspect = vim.inspect_pos(0, vim.v.foldstart - 1, i, {})
    local hl

    local treesitter_length = #inspect.treesitter

    if treesitter_length > 0 then
      hl = inspect.treesitter[treesitter_length].hl_group
    else
      hl = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.v.foldstart, i+1, 1)), 'name')
    end
    table.insert(virt_texts, {string.sub(line_text, i+1, i+1), hl or 'None'})
  end

  table.insert(virt_texts, {
    " " .. vim.v.foldstart .. " - " .. vim.v.foldend .. " ",
    'Comment'
  })

  return virt_texts
end

vim.opt.foldtext = "v:lua.FoldText()"
