local dap = require("dap")

dap.adapters.java = function(callback, config)
  callback({
    type = 'server',
    host = '127.0.0.1',
    port = config.port or 5005
  })
end

dap.configurations.java = {
  {
    type = 'java',
    request = 'launch',
    name = 'Launch Java Program',
    mainClass = function()
      return vim.fn.input('Main class: ')
    end,
    projectName = function()
      return vim.fn.input('Project name: ')
    end,
    args = {},
    cwd = vim.fn.getcwd(),
  },
}
