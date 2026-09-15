local dap = require "dap"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = "codelldb",
        args = { "--port", "${port}" },
    },
}

dap.configurations.cpp = {
    {
        name = "C++",
        type = "codelldb",
        request = "launch",

        program = function()
            local src = vim.fn.expand "%:p"
            local exe = vim.fn.expand "%:p:r"

            vim.fn.system {
                "clang++",
                "-std=c++20",
                "-glldb",
                "-fstandalone-debug",
                src,
                "-o",
                exe,
            }

            return exe
        end,
        cwd = "${workspaceFolder}",
    },
}
