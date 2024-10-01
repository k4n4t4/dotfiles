function FoldText()
  local virt_texts = {}

  local line_text = vim.fn.getline(vim.v.foldstart)
  local i = 1
  while i <= #line_text do
    local hl

    local inspect = vim.inspect_pos(0, vim.v.foldstart - 1, i - 1, {})
    local treesitter_length = #inspect.treesitter
    if treesitter_length > 0 then
      hl = inspect.treesitter[treesitter_length].hl_group
    else
      hl = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(vim.v.foldstart, i, 1)), 'name')
    end

    local byte = string.byte(line_text, i)
    local char
    if byte == 0 then
      char = ""
    elseif byte < 128 then
      char = string.sub(line_text, i, i)
    elseif byte < 192 then
      char = ""
    elseif byte < 224 then
      char = string.sub(line_text, i, i+1)
      i = i + 1
    elseif byte < 240 then
      char = string.sub(line_text, i, i+2)
      i = i + 2
    elseif byte < 248 then
      char = string.sub(line_text, i, i+3)
      i = i + 3
    elseif byte < 252 then
      char = string.sub(line_text, i, i+4)
      i = i + 4
    elseif byte < 254 then
      char = string.sub(line_text, i, i+5)
      i = i + 5
    else
      char = ""
    end

    table.insert(
      virt_texts,
      {
        char,
        hl or 'None',
      }
    )

    i = i + 1
  end

  table.insert(virt_texts, {
    " " .. vim.v.foldstart .. " - " .. vim.v.foldend .. " ",
    'Comment'
  })

  return virt_texts
end

vim.opt.foldtext = "v:lua.FoldText()"
