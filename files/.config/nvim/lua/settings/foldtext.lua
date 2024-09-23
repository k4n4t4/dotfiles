function FoldText()
  return ""
end

vim.opt.foldtext = "v:lua.FoldText()"
-- vim.opt.foldtext = ""


vim.api.nvim_create_autocmd({
  'CursorMoved',
}, {
  callback = function()

    local bnr = vim.fn.bufnr('%')
    local ns_id = vim.api.nvim_create_namespace("fold")

    vim.api.nvim_buf_clear_namespace(bnr, ns_id, vim.fn.line('w0') - 1, vim.fn.line('w$'))

    for i = vim.fn.line('w0'), vim.fn.line('w$') do
      if vim.fn.foldlevel(i) > 0 then
        local fold_closed = vim.fn.foldclosed(i)
        if fold_closed ~= -1 then

          local text = {}

          for j = 1, #vim.fn.getline(fold_closed) do
              local syn_id = vim.fn.synID(fold_closed, j, 1)
              local name = vim.fn.synIDattr(syn_id, 'name')
              local hl = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.synID(fold_closed, j, 1)), 'name')
              table.insert(text , {'@', hl or 'Comment'})
          end

          local opts = {
            id = fold_closed,
            -- virt_text = {{vim.fn.getline(fold_closed), "type"}},
            virt_text = text,
            virt_text_pos = 'overlay',
          }

          local mark_id = vim.api.nvim_buf_set_extmark(
            bnr, ns_id, fold_closed - 1, 0, opts
          )
        end
      end
    end
  end
})
