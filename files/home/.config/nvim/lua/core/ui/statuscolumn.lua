vim.opt.foldcolumn = "0"
vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"


local statuscolumn_group = vim.api.nvim_create_augroup("StatusColumn", { clear = true })

-- Override highlights
local function status_column_highlights()
  local hls = {
    {"StatusColumn", {
      fg = "#EEEEEE";
      bg = "none";
    }},
    {"StatusColumnNC", {
      fg = "#AAAAAA";
      bg = "none";
    }},
    {"StatusColumnFoldHead", {
      fg = "#4466CC";
      bg = "none";
    }},
    {"StatusColumnFold", {
      fg = "#224466";
      bg = "none";
    }},
  }
  for _, v in pairs(hls) do
    local name = v[1]
    local params = v[2]
    vim.api.nvim_set_hl(0, name, params)
  end
end
vim.api.nvim_create_autocmd({
  "VimEnter",
  "ColorScheme",
}, {
  group = statuscolumn_group;
  callback = status_column_highlights;
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
  end
})

local function status_fold()
  if utils_fold then
    local winnr = vim.api.nvim_get_current_win()
    local fi = utils_fold.get(winnr, vim.v.lnum)

    if fi.lnum == vim.v.lnum then
      if vim.v.virtnum == 0 then
        if fi.folded then
          return "%#StatusColumnFoldHead#>%*"
        else
          return "%#StatusColumnFoldHead#v%*"
        end
      else
        return "%#StatusColumnFold#¦%*"
      end
    elseif fi.level ~= 0 then
      return "%#StatusColumnFold#¦%*"
    else
      return " "
    end
  else
    return "%C"
  end
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
