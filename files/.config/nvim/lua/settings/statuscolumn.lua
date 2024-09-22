local function status_line_number()
  return (
    [[%{ &rnu ? ( v:lnum == line(".") ? (v:lnum) : (v:relnum) ) : (v:lnum) }]]
  )
end

function StatusColumn()
  local line_number = status_line_number()
  return (
    "%s" ..
    "%=" ..
    line_number ..
    "%C" ..
    [[%{v:lnum == line(".") ? "▌" : "│" }]]
  )
end

function StatusColumnInactive()
  return (
    "%s" ..
    "%=" ..
    "%l" ..
    "%C" ..
    "│"
  )
end

vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"
