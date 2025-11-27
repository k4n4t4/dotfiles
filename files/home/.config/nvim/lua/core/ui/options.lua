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
