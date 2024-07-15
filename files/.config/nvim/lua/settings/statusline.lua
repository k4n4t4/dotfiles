vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function ()
    vim.api.nvim_set_hl(0, 'StatusLine', {
      fg = '#EEEEEE',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeNormal', {
      fg = '#99EE99',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeInsert', {
      fg = '#EE9999',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeReplace', {
      fg = '#EEEE99',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeVisual', {
      fg = '#9999EE',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeConfirm', {
      fg = '#999999',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeTerminal', {
      fg = '#999999',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineModeOther', {
      fg = '#EE99EE',
      bg = '#202020',
    })

    vim.api.nvim_set_hl(0, 'StatusLineDiagnosticINFO', {
      fg = '#99EEEE',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineDiagnosticWARN', {
      fg = '#EEEE99',
      bg = '#202020',
    })
    vim.api.nvim_set_hl(0, 'StatusLineDiagnosticERROR', {
      fg = '#EE9999',
      bg = '#202020',
    })
  end
})

local mode_name = {
  ['n']    = 'N',
  ['no']   = 'NO',
  ['nov']  = 'NOC',
  ['noV']  = 'NOL',
  ['no^V'] = 'NOB',

  ['niI'] = 'NI',
  ['niR'] = 'NR',
  ['niV'] = 'NV',
  ['nt']  = 'NT',
  ['ntT'] = 'NTT',

  ['v']   = 'V',
  ['vs']  = 'VS',
  ['V']   = 'VL',
  ['Vs']  = 'VLS',
  ['']  = 'VB',
  ['s'] = 'VBS',

  ['s']  = 'S',
  ['S']  = 'SL',
  [''] = 'SB',

  ['i']  = 'I',
  ['ic'] = 'IC',
  ['ix'] = 'IX',

  ['R']   = 'R',
  ['Rc']  = 'RC',
  ['Rx']  = 'RX',
  ['Rv']  = 'RV',
  ['Rvc'] = 'RVC',
  ['Rvx'] = 'RVX',

  ['c']  = 'C',
  ['cr'] = 'CR',

  ['cv']  = 'EX',
  ['cvr'] = 'EXR',

  ['r']  = 'P',
  ['rm'] = 'M',
  ['r?'] = 'CF',
  ['!']  = 'SH',
  ['t']  = 'T',
}

local mode_color = {
  ['n']    = 'StatusLineModeNormal',
  ['no']   = 'StatusLineModeNormal',
  ['nov']  = 'StatusLineModeNormal',
  ['noV']  = 'StatusLineModeNormal',
  ['no^V'] = 'StatusLineModeNormal',
  ['v']    = 'StatusLineModeVisual',
  ['vs']   = 'StatusLineModeVisual',
  ['V']    = 'StatusLineModeVisual',
  ['Vs']   = 'StatusLineModeVisual',
  ['']   = 'StatusLineModeVisual',
  ['s']  = 'StatusLineModeVisual',
  ['i']    = 'StatusLineModeInsert',
  ['ic']   = 'StatusLineModeInsert',
  ['ix']   = 'StatusLineModeInsert',
  ['R']    = 'StatusLineModeReplace',
  ['Rc']   = 'StatusLineModeReplace',
  ['Rx']   = 'StatusLineModeReplace',
  ['Rv']   = 'StatusLineModeReplace',
  ['Rvc']  = 'StatusLineModeReplace',
  ['Rvx']  = 'StatusLineModeReplace',
  ['r?']   = 'StatusLineModeConfirm',
  ['!']    = 'StatusLineModeTerminal',
  ['t']    = 'StatusLineModeTerminal',
}

local function status_mode()
  local mode = vim.api.nvim_get_mode().mode
  local name = mode_name[mode] or "?"
  local color = mode_color[mode] or 'StatusLineModeOther'
  return { color = color, name = name }
end

local function status_encoding()
  return vim.o.fenc or vim.o.enc
end

local function status_fileformat()
  return vim.o.ff
end

local filetype_name = {
  ['javascript'] = 'js',
  ['typescript'] = 'ts',
}
local function status_filetype()
  local ft = vim.o.ft
  return (not ft or ft == '') and '' or (filetype_name[ft] or ft)
end

local function status_lsp()
  local clients = {}
  for _, client in ipairs(vim.lsp.get_active_clients { bufnr = 0 }) do
    if client.name == 'null-ls' then
      local sources = {}
      for _, source in ipairs(require('null-ls.sources').get_available(vim.bo.filetype)) do
        table.insert(sources, source.name)
      end
      table.insert(clients, 'null-ls(' .. table.concat(sources, ', ') .. ')')
    else
      table.insert(clients, client.name)
    end
  end
  return clients
end

local function status_diagnostic()
  local diagnoses = {}
  for _, v in pairs({ 'ERROR', 'WARN', 'INFO' }) do
    local t = vim.diagnostic.get(0, { severity = vim.diagnostic.severity[v] })
    if t ~= nil and #t > 0 then
      table.insert(diagnoses, '%#StatusLineDiagnostic' .. v .. '#' .. tostring(#t) .. '%*')
    end
  end
  return diagnoses
end

local function status_macro_recording()
  return vim.fn.reg_recording()
end

local function status_search_count()
  return vim.fn.searchcount()
end


function status_line()
  local macro = status_macro_recording()
  local mode = status_mode()
  local search = status_search_count()
  local lsp = status_lsp()
  local diagnostic = status_diagnostic()

  local macro_format = ""
  if macro ~= "" then
    macro_format = "@"..macro.." "
  end

  local mode_format = "%#"..mode.color.."#"..mode.name.."%*"

  local search_format = ""
  if vim.v.hlsearch == 1 then
    search_format = "["..search.current.."/"..search.total.."] "
  end

  local lsp_format = ""
  if #lsp > 0 then
    lsp_format = " "..table.concat(lsp, ", ")
  end

  local diagnostic_format = ""
  if #diagnostic > 0 then
    diagnostic_format = " "..table.concat(diagnostic, ", ")
  end


  return (
    macro_format ..
    mode_format ..
    " %f%h%m%r%w" ..
    lsp_format..
    diagnostic_format..
    "%=%<" ..
    "%S "..
    search_format ..
    status_encoding().." " ..
    status_fileformat().." " ..
    status_filetype().." " ..
    "%B %l/%L,%c%V %P"
  )
end
function status_line_inactive()
  return (
    "%f%h%m%r%w" ..
    "%=%<" ..
    "%B %l/%L,%c%V %P"
  )
end

vim.api.nvim_create_autocmd({
  'BufEnter',
  'WinEnter',
  'TabEnter',
}, {
  group = vim.api.nvim_create_augroup('StatusLine', {}),
  pattern = '*',
  callback = function ()
    for _, id in pairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_get_current_win() == id then
        vim.opt.statusline = "%!v:lua.status_line()"
      elseif vim.api.nvim_buf_get_name(0) ~= '' then
        vim.opt.statusline = "%!v:lua.status_line_inactive()"
      end
    end
  end,
})
