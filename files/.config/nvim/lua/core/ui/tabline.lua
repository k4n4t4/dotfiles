vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.TabLine()"


local tabline_group = vim.api.nvim_create_augroup("TabLine", { clear = true })

-- Override highlights
local function tabline_highlights()
  local hls = {
    {"TabLine", {
      fg = "none",
      bg = "#202020",
    }},
    {"TabLineFill", {
      fg = "none",
      bg = "#111111",
    }},
    {"TabLineFileName", {
      fg = "#A0A0A0",
      bg = "#202020",
    }},
    {"TabLineUntitled", {
      fg = "#707070",
      bg = "#202020",
      italic = true,
    }},
    {"CurrentTabLine", {
      fg = "none",
      bg = "#404040",
    }},
    {"CurrentTabLineFileName", {
      fg = "#E0E0E0",
      bg = "#404040",
    }},
    {"CurrentTabLineUntitled", {
      fg = "#909090",
      bg = "#404040",
      italic = true,
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
  group = tabline_group,
  callback = tabline_highlights
})


local devicons
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local result, ret = pcall(require, "nvim-web-devicons")
    if result then
      devicons = ret
    end
  end,
})


function TabLine()
  local tab_length = vim.fn.tabpagenr('$')
  local tabline_items = {}

  for tabnr = 1, tab_length do
    local tab_id = "%" .. tabnr .. "T"
    local is_current_tab = tabnr == vim.fn.tabpagenr()

    local buf_list = vim.fn.tabpagebuflist(tabnr)
    local winnr = vim.fn.tabpagewinnr(tabnr)
    local bufnr = buf_list[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local buf_count = #buf_list
    local buf_modified = vim.bo[bufnr].modified
    local filename = vim.fn.fnamemodify(bufname, ":t")
    local filetype = vim.bo[bufnr].ft or ""

    local tabline_hl
    if is_current_tab then
      tabline_hl = "%#CurrentTabLine#"
    else
      tabline_hl = "%#TabLine#"
    end

    local icon = ""
    local icon_hl = ""
    if devicons then
      local color
      icon, color = devicons.get_icon_color_by_filetype(filetype)
      if icon then
        icon_hl = (is_current_tab and "Current" or "") .. "TabLineIcon@" .. filetype

        vim.api.nvim_set_hl(0, icon_hl, {
          fg = color,
          bg = is_current_tab and "#404040" or "#202020",
        })

        icon_hl = "%#" .. icon_hl .. "#"
      else
        icon = ""
      end
    end

    local filename_fmt = ""
    local file_name_hl
    if filename == "" then
      filename_fmt = "Untitled"
      if is_current_tab then
        file_name_hl = "%#CurrentTabLineUntitled#"
      else
        file_name_hl = "%#TabLineUntitled#"
      end
    else
      filename_fmt = filename
      if is_current_tab then
        file_name_hl = "%#CurrentTabLineFileName#"
      else
        file_name_hl = "%#TabLineFileName#"
      end
    end

    local buf_count_fmt
    if not is_current_tab and buf_count > 1 then
      buf_count_fmt = "(" .. buf_count .. ")"
    else
      buf_count_fmt = ""
    end

    local buf_modified_fmt
    if buf_modified then
      buf_modified_fmt = "*"
    else
      buf_modified_fmt = ""
    end

    local components = {
      tabline_hl,
      tab_id,
      icon == "" and "" or " ",
      icon_hl,
      icon,
      " ",
      file_name_hl,
      buf_modified_fmt,
      filename_fmt,
      buf_count_fmt,
      " ",
    }

    table.insert(tabline_items, table.concat(components, ""))
  end

  return table.concat(tabline_items, "") .. "%#TabLineFill#" .. "%T"
end
