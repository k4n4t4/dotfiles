local M = {}

local commands = {
    python = "python %s",
    lua = "lua %s",
    sh = "bash %s",
}

function M.get_command()
    local filetype = vim.bo.filetype
    local command = commands[filetype]

    if not command then
        return nil
    end

    return command:format(vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
end

function M.run(run_command)
    if not run_command or run_command == "" then
        run_command = M.get_command()
        if not run_command then
            return
        end
    end

    if Snacks and Snacks.terminal then
        Snacks.terminal(run_command, {
            win = { style = "float" },
            auto_close = false,
        })
    else
        vim.fn.jobstart(run_command, {
            term = true,
        })
    end
end

return M
