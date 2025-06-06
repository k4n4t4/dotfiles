function Config(config)
  local config = config or {}

  if config then

    if config.shell then
      vim.opt.shell = config.shell
    end

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

    if config.run then
      config.run()
    end

  end
end
