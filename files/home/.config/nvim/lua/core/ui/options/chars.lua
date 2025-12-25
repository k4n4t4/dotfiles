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
    horiz = "━";
    horizup = "┻";
    horizdown = "┳";
    vert = "┃";
    vertleft = "┨";
    vertright = "┣";
    verthoriz = "╋";
    diff = "┃";
    msgsep = "‾";
}
