---@class LocalConfigColorscheme
---@field name string|nil
---@field transparent boolean|nil

---@class LocalConfig
---@field shell string|nil
---@field colorscheme LocalConfigColorscheme|nil
---@field mouse string|boolean|nil
---@field run fun()|nil

---@param config LocalConfig
---@return nil
return function(config)
  config = config or {}

  if config then

    if config.shell then
      vim.opt.shell = config.shell
    end

    if config.colorscheme then

      if config.colorscheme.transparent then
        local plugins_transparent = require("utils.transparent")
        plugins_transparent.setup {}
      end

      if config.colorscheme.name then
        vim.cmd.colorscheme(config.colorscheme.name)
      end

    end

    if config.mouse then
      if config.mouse == true then
        vim.opt.mouse = "a"
      else
        vim.opt.mouse = config.mouse
      end
    else
      vim.opt.mouse = ""
    end

    if config.run then
      config.run()
    end

  end
end
