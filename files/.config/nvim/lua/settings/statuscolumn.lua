function StatusColumn()
  return (
    [[%s]] ..
    [[%=]] ..
    [[%{ &rnu ? (v:relnum) : (v:lnum) }]] ..
    [[%C]] ..
    [[│]]
  )
end

function StatusColumnInactive()
  return (
    [[%s]] ..
    [[%=]] ..
    [[%l]] ..
    [[%C]] ..
    [[│]]
  )
end

vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"
