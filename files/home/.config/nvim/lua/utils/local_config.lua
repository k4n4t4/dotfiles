---@class LocalConfigColorscheme
---@field name string|nil
---@field transparent boolean|nil

---@class LocalConfigNumber
---@field enable boolean|nil
---@field relative boolean|nil
---@field toggle_relative_number boolean|nil

---@class LocalConfig
---@field shell string|nil
---@field colorscheme LocalConfigColorscheme|nil
---@field number LocalConfigNumber|boolean|nil
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

    if config.number then

      if config.number.enable == false then
        vim.opt.number = false
      else
        vim.opt.number = true
      end

      if config.number.relative == false then
        vim.opt.relativenumber = false
        require("utils.toggle_relnumber").disable()
      else
        vim.opt.relativenumber = true

        if config.number.toggle_relative_number then
          require("utils.toggle_relnumber").enable()
        end

      end

    elseif config.number == false then

      vim.opt.number = false

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
