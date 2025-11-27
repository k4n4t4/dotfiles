vim.opt.list = true
vim.opt.listchars = {
  tab      = ">-";
  extends  = ">";
  precedes = "<";
  trail    = "-";
  nbsp     = "+";
  conceal  = "@";
}
vim.opt.fillchars = {
  eob = " ";
  fold = "·";
  foldopen = "v";
  foldsep = "¦";
  foldclose = ">";
}

vim.diagnostic.config {
  virtual_text = true,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "!";
      [vim.diagnostic.severity.WARN] = "*";
      [vim.diagnostic.severity.HINT] = "?";
      [vim.diagnostic.severity.INFO] = "i";
    };
  };
}

if not vim.g.loaded_netrw then
  vim.g.netrw_liststyle = 3
  vim.g.netrw_banner = 0
  vim.g.netrw_sizestyle = "H"
  vim.g.netrw_timefmt = "%m-%d-%Y %a %H:%M:%S"
  vim.g.netrw_preview = 1
  vim.g.netrw_winsize = 30
  vim.g.netrw_browse_split = 3
end
