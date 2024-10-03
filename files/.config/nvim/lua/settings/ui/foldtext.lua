function FoldText()
  return ""
end
-- vim.opt.foldtext = "v:lua.FoldText()"
vim.opt.foldtext = ""


local namespace = vim.api.nvim_create_namespace("foldtext")

if vim.opt.foldtext["_value"] == "" then
  vim.api.nvim_set_decoration_provider(namespace, {
    on_win = function(_, winid, bufnr, toprow, botrow)
      vim.api.nvim_win_call(winid, function()
        local lnum = toprow + 1
        while lnum <= botrow + 1 do
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
              {'Bold', 'Comment'},
            })
            table.insert(virt_texts, {
              " " .. fold_start .. " - " .. fold_end .. " " ..
              (fold_level == 1 and "" or "(" .. fold_level .. ") "),
              {'Comment', 'Underlined'},
            })

            vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum-1, 0, {
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
else
  vim.api.nvim_set_decoration_provider(namespace, {
    on_win = function(_, winid, bufnr, toprow, botrow)
      local ts_active = vim.treesitter.highlighter.active[bufnr]
      vim.api.nvim_win_call(winid, function()
        local lnum = toprow + 1
        while lnum <= botrow + 1 do
          local fold_start = vim.fn.foldclosed(lnum)
          if fold_start == -1 then
            lnum = lnum + 1
          else
            local line_text = vim.fn.getline(lnum)
            local fold_end = vim.fn.foldclosedend(lnum)
            local fold_level = vim.fn.foldlevel(lnum)

            local virt_texts = {}

            local i = 1
            while i <= #line_text do
              local hl

              if ts_active then
                local captures = vim.treesitter.get_captures_at_pos(bufnr, lnum-1, i-1)
                if #captures > 0 then
                  hl = "@" .. captures[#captures].capture
                end
              end
              hl = hl or vim.fn.synIDattr(vim.fn.synID(lnum, i, true), 'name')

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

              table.insert(virt_texts, {
                " ▼ ",
                {'Bold', 'Comment'},
              })
              table.insert(virt_texts, {
                " " .. fold_start .. " - " .. fold_end .. " " ..
                  (fold_level == 1 and "" or "(" .. fold_level .. ") "),
                {'Comment', 'Underlined'},
              })

              i = i + 1
            end

            table.insert(virt_texts, {
              " " .. fold_start .. " - " .. fold_end .. " [" .. fold_level .. "] ",
              'Comment'
            })

            vim.api.nvim_buf_set_extmark(bufnr, namespace, lnum-1, 0, {
              ephemeral = true,
              virt_text_pos = 'overlay',
              hl_mode = 'combine',
              virt_text = virt_texts
            })

            lnum = fold_end + 1
          end
        end
      end)
    end
  })
end
