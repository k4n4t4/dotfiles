if config.transparent then
  require("commands.transparent").setup {
    events = {
      "VimEnter",
      "ColorScheme",
    }
  }
end

if config.colorscheme then
  vim.cmd.colorscheme(config.colorscheme)
end
