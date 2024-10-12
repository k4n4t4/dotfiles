vim.opt.foldcolumn = "0"
vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"


local function status_column_highlights()
  vim.api.nvim_set_hl(0, "StatusColumn", {
    fg = "#EEEEEE",
    bg = "none",
  })
  vim.api.nvim_set_hl(0, "StatusColumnNC", {
    fg = "#AAAAAA",
    bg = "none",
  })
  vim.api.nvim_set_hl(0, "StatusColumnFold", {
    fg = "#224466",
    bg = "none",
  })
end

vim.api.nvim_create_autocmd({
  "VimEnter",
  "ColorScheme",
}, {
  callback = status_column_highlights
})

local function status_line_number()
  local line_number = ""
  if vim.v.virtnum == 0 then
    if vim.wo.relativenumber then
      if vim.v.lnum == vim.fn.line(".") then
        line_number = line_number .. vim.v.lnum
      else
        line_number = line_number .. vim.v.relnum
      end
    else
      line_number = line_number .. vim.v.lnum
    end
  else
    line_number = line_number .. "▕"
  end
  return line_number
end


local utils_fold
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    utils_fold = require "utils.fold"
  end,
})

local function status_fold()
  if utils_fold then
    local winnr = vim.api.nvim_get_current_win()
    local fi = utils_fold.get(winnr, vim.v.lnum)

    if fi.lnum == vim.v.lnum then
      if vim.v.virtnum == 0 then
        if fi.folded then
          return ">"
        else
          return "v"
        end
      else
        return "¦"
      end
    elseif fi.level ~= 0 then
      return "¦"
    else
      return " "
    end
  else
    return "%C"
  end
end

local function status_fold_hl()
  return "%#StatusColumnFold#"
end

local function status_separator()
  if vim.v.lnum == vim.fn.line(".") then
    return "▌"
  else
    return "│"
  end
end

local function status_separator_hl()
  if vim.v.lnum == vim.fn.line(".") then
    return "%#CursorLineNr#"
  else
    return "%#LineNr#"
  end
end

function StatusColumn()
  if vim.wo.number then
    local line_number = status_line_number()
    local fold = status_fold()
    local fold_hl = status_fold_hl()
    local separator = status_separator()
    local separator_hl = status_separator_hl()
    return (
      "%s" ..
      "%=" ..
      line_number ..
      fold_hl ..
      fold ..
      separator_hl ..
      separator
    )
  else
    return ""
  end
end

function StatusColumnInactive()
  if vim.wo.number then
    local fold = status_fold()
    return (
      "%s" ..
      "%=" ..
      "%l" ..
      fold ..
      "│"
    )
  else
    return ""
  end
end
