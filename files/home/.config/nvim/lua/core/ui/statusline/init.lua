require "core.ui.statusline.highlights"
require "core.ui.statusline.format"

-- Redraw statusline when mode changed. (e.g. 'ix' mode)
vim.api.nvim_create_autocmd("ModeChanged", {
  group = statusline_group;
  callback = function()
    vim.cmd.redrawstatus()
  end;
})

vim.opt.ruler = false
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"

vim.opt.laststatus = 3
vim.opt.statusline = "%{% v:lua.StatusLine(g:actual_curwin == win_getid()) %}"
