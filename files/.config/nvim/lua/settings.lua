if config.colorscheme then
  if config.colorscheme.transparent then
    require("commands.transparent").setup {
      events = {
        "VimEnter",
        "ColorScheme",
      }
    }
  end

  if config.colorscheme.name then
    vim.cmd.colorscheme(config.colorscheme.name)
  end
end
