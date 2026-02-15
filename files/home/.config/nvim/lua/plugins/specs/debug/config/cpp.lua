local dap = require("dap")

dap.adapters.lldb = {
    type = 'executable',
    command = 'lldb-dap',
    name = 'lldb',
}

dap.configurations.cpp = {
    {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
    },
}

dap.configurations.c = dap.configurations.cpp
