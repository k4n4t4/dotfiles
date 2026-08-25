local M = {}

M.default_commands = {
    python = "python %s",
    lua = "lua %s",
    sh = "bash %s",
}

M.project_markers = {
    {
        files = { "uv.lock", "pyproject.toml" },
        cmd = function(root)
            local f = io.open(root .. "/pyproject.toml")
            local name = f and f:read("*a"):match('%[project%].-name%s*=%s*"([^"]+)"')
            if f then
                f:close()
            end
            return "cd "
            .. vim.fn.shellescape(root)
            .. " && uv run "
            .. (name and vim.fn.shellescape(name) or "python " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
        end,
    },
    {
        files = { "Cargo.toml" },
        cmd = function(root)
            return "cd " .. vim.fn.shellescape(root) .. " && cargo run"
        end,
    },
    {
        files = { "build.gradle.kts", "build.gradle" },
        cmd = function(root)
            local gradlew = root .. "/gradlew"
            local exe = vim.fn.executable(gradlew) == 1 and vim.fn.shellescape(gradlew) or "gradle"
            return "cd " .. vim.fn.shellescape(root) .. " && " .. exe .. " run"
        end,
    },
    {
        files = { "go.mod" },
        cmd = function(root)
            return "cd " .. vim.fn.shellescape(root) .. " && go run ."
        end,
    },
    {
        files = { "package.json" },
        cmd = function(root)
            return "cd " .. vim.fn.shellescape(root) .. " && npm run dev"
        end,
    },
    {
        files = { "Makefile" },
        cmd = function(root)
            return "cd " .. vim.fn.shellescape(root) .. " && make"
        end,
    },
}

function M.detect_project_command()
    local start = vim.fn.expand("%:p:h")
    for _, entry in ipairs(M.project_markers) do
        local found = vim.fs.find(entry.files, { upward = true, path = start })
        if found[1] then
            local root = vim.fs.dirname(found[1])
            return entry.cmd(root)
        end
    end
    return nil
end

function M.get_command()
    local project_cmd = M.detect_project_command()
    if project_cmd then
        return project_cmd
    end

    local filetype = vim.bo.filetype
    local command = M.default_commands[filetype]
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

function M.run_with_args(run_command)
    if not run_command or run_command == "" then
        run_command = M.get_command()
        if not run_command then
            return
        end
    end
    local args = vim.fn.input("Arguments: ")
    if args ~= "" then
        run_command = run_command .. " " .. args
    end
    M.run(run_command)
end

return M
