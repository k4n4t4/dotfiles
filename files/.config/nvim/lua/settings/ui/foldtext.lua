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

function FoldTextExtMark()
  local bnr = vim.api.nvim_get_current_buf()
  local ns_id = vim.api.nvim_create_namespace("foldtext")

  local start_line = vim.fn.line('w0')
  local end_line = vim.fn.line('w$')

  vim.api.nvim_buf_clear_namespace(bnr, ns_id, start_line - 1, end_line)

  local line_nr = start_line
  while line_nr <= end_line do
    local fold_start = vim.fn.foldclosed(line_nr)
    if fold_start ~= -1 then
      local fold_end = vim.fn.foldclosedend(line_nr)

      local virt_texts = {}

      local line_text = vim.fn.getline(line_nr)
      for i = 0, #line_text-1 do
        local inspect = vim.inspect_pos(bnr, line_nr - 1, i, {})
        local hl

        local treesitter_length = #inspect.treesitter

        if treesitter_length > 0 then
          hl = inspect.treesitter[treesitter_length].hl_group
        else
          hl = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(line_nr, i+1, 1)), 'name')
        end
        table.insert(virt_texts, {string.sub(line_text, i+1, i+1), hl or 'None'})
      end

      table.insert(virt_texts, {
        " " .. fold_start .. " - " .. fold_end .. " ",
        'Comment'
      })

      local opts = {
        id = fold_start,
        virt_text = virt_texts,
        virt_text_pos = 'overlay',
      }
      vim.api.nvim_buf_set_extmark(
        bnr, ns_id, fold_start - 1, 0, opts
      )


      line_nr = fold_end
    end
    line_nr = line_nr + 1
  end
end
