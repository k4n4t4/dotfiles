vim.opt.list = true
vim.opt.listchars = {
  tab      = ">-",
  extends  = ">",
  precedes = "<",
  trail    = "-",
  nbsp     = "+",
  conceal  = "@",
}
vim.opt.fillchars = {
  eob = " ",
  fold = "·",
  foldopen = "v",
  foldsep = "¦",
  foldclose = ">",
}

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "!",
      [vim.diagnostic.severity.WARN] = "*",
      [vim.diagnostic.severity.HINT] = "?",
      [vim.diagnostic.severity.INFO] = "i",
    },
  },
}
