function FoldText()
  return ""
end

vim.opt.foldtext = "v:lua.FoldText()"
-- vim.opt.foldtext = ""


local function foldtext()
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
      local line_text = vim.fn.getline(line_nr)

      local virt_texts = {}
      for i = 0, #line_text-1 do
        local inspect = vim.inspect_pos(bnr, line_nr - 1, i, {})
        local hl

        local treesitter_length = #inspect.treesitter

        if treesitter_length > 0 then
          hl = hl or inspect.treesitter[treesitter_length].hl_group
        end
        table.insert(virt_texts, {"@", hl or 'None'})
      end

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

vim.api.nvim_create_autocmd({
  'CursorMoved',
}, {
  callback = function()
    foldtext()
  end
})
