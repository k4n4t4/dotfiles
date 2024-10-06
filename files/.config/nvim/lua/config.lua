require("commands.transparent").setup {
  events = {
    "VimEnter",
    "ColorScheme",
  }
}

vim.cmd.colorscheme "everforest"
