local utils_fold = require "utils.fold"


local function status_line_number()
  if vim.v.virtnum == 0 then
    if vim.wo.relativenumber then
      if vim.v.lnum == vim.fn.line(".") then
        return tostring(vim.v.lnum)
      end
      return tostring(vim.v.relnum)
    end
    return tostring(vim.v.lnum)
  end
  return "▕"
end

local function status_fold()
  if utils_fold then
    local winnr = vim.api.nvim_get_current_win()
    local fi = utils_fold.get(winnr, vim.v.lnum)

    if fi.lnum == vim.v.lnum then
      if vim.v.virtnum == 0 then
        if fi.folded then
          return "%#StatusColumnFoldHead#>%*"
        end
        return "%#StatusColumnFoldHead#v%*"
      end
      return "%#StatusColumnFold#¦%*"
    end

    if fi.level ~= 0 then
      return "%#StatusColumnFold#¦%*"
    end

    return " "
  end

  return "%C"
end

local function status_separator()
  if vim.v.lnum == vim.fn.line(".") then
    return "%#CursorLineNr#▌%*"
  else
    return "%#LineNr#│%*"
  end
end


function StatusColumn()
  if vim.wo.number then
    local line_number = status_line_number()
    local fold = status_fold()
    local separator = status_separator()
    return (
      "%s" ..
      "%=" ..
      line_number ..
      fold ..
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
