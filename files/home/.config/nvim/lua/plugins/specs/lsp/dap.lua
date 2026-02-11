return {
    "mfussenegger/nvim-dap";
    dependencies = {
        "rcarriga/nvim-dap-ui";
        "nvim-neotest/nvim-nio";
    };
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup()

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        dap.adapters.lldb = {
            type = 'executable';
            command = 'lldb-dap';
            name = 'lldb';
        }

        vim.keymap.set('n', '<F5>', function() dap.continue() end)
        vim.keymap.set('n', '<F10>', function() dap.step_over() end)
        vim.keymap.set('n', '<F11>', function() dap.step_into() end)
        vim.keymap.set('n', '<F12>', function() dap.step_out() end)
        vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)


        -- cpp, c
        dap.configurations.cpp = {
            {
                name = 'Launch';
                type = 'lldb';
                request = 'launch';
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end;
                cwd = '${workspaceFolder}';
                stopOnEntry = false;
                args = {};
            },
        }
        dap.configurations.c = dap.configurations.cpp
    end;
    event = 'VeryLazy';
}
