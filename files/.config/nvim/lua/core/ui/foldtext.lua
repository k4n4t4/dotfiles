vim.opt.foldcolumn = '0'
vim.opt.foldtext = ""


local namespace = vim.api.nvim_create_namespace("foldtext")

vim.api.nvim_set_decoration_provider(namespace, {
  on_win = function(_, winid, bufnr, toprow, botrow)
    vim.api.nvim_win_call(winid, function()
      local lnum = toprow + 1
      while lnum <= botrow do
        local fold_start = vim.fn.foldclosed(lnum)
        if fold_start == -1 then
          lnum = lnum + 1
        else
          local line_text = vim.fn.getline(lnum)
          local fold_end = vim.fn.foldclosedend(lnum)
          local fold_level = vim.fn.foldlevel(lnum)

          local virt_texts = {}

          table.insert(virt_texts, {
            " ▼ ",
            {"Bold", "Comment"},
          })
          table.insert(virt_texts, {
            " " .. fold_start .. " - " .. fold_end .. " " ..
              (fold_level == 1 and "" or "(" .. fold_level .. ") "),
            {"Comment", "Underlined"},
          })

          pcall(vim.api.nvim_buf_set_extmark, bufnr, namespace, lnum-1, 0, {
            ephemeral = true,
            virt_text_pos = 'overlay',
            virt_text_win_col = vim.fn.strdisplaywidth(line_text),
            hl_mode = 'combine',
            virt_text = virt_texts,
          })

          lnum = fold_end + 1
        end
      end
    end)
  end
})
