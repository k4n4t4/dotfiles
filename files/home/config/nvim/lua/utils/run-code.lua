local M = {}

local function with_args(cmd, args, sep)
    return cmd .. (args ~= "" and (sep or " ") .. args or "")
end

M.default_commands = {
    ["python"] = function(file, args)
        return with_args("python " .. file, args)
    end,
    ["lua"] = function(file, args)
        return with_args("lua " .. file, args)
    end,
    ["sh"] = function(file, args)
        return with_args("bash " .. file, args)
    end,
    ["zsh"] = function(file, args)
        return with_args("zsh " .. file, args)
    end,
    ["ruby"] = function(file, args)
        return with_args("ruby " .. file, args)
    end,
    ["php"] = function(file, args)
        return with_args("php " .. file, args)
    end,
    ["javascript"] = function(file, args)
        return with_args("node " .. file, args)
    end,
    ["typescript"] = function(file, args)
        return with_args("tsx " .. file, args)
    end,
    ["r"] = function(file, args)
        return with_args("Rscript " .. file, args)
    end,
    ["perl"] = function(file, args)
        return with_args("perl " .. file, args)
    end,
}

M.project_markers = {
    {
        files = { "uv.lock", "pyproject.toml" },
        cmd = function(root, args)
            local name
            if vim.fn.filereadable(root .. "/uv.lock") == 1 then
                local f = io.open(root .. "/pyproject.toml")
                if f then
                    local in_project = false
                    for line in f:lines() do
                        local section = line:match("^%s*%[([%w%.%-_]+)%]%s*$")
                        if section then
                            in_project = (section == "project")
                        elseif in_project then
                            name = line:match('^%s*name%s*=%s*"([^"]+)"%s*$')
                            if name then
                                break
                            end
                        end
                    end
                    f:close()
                end
            end
            local target = name
            and vim.fn.shellescape(name)
            or ("python " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)))
            return with_args("cd " .. vim.fn.shellescape(root) .. " && uv run " .. target, args)
        end,
    },
    {
        files = { "Cargo.toml" },
        cmd = function(root, args)
            return with_args("cd " .. vim.fn.shellescape(root) .. " && cargo run", args, " -- ")
        end,
    },
    {
        files = { "build.gradle.kts", "build.gradle" },
        cmd = function(root, args)
            local gradlew = root .. "/gradlew"
            local exe = vim.fn.executable(gradlew) == 1
            and vim.fn.shellescape(gradlew)
            or "gradle"
            return with_args("cd " .. vim.fn.shellescape(root) .. " && " .. exe .. " run", args)
        end,
    },
    {
        files = { "go.mod" },
        cmd = function(root, args)
            return with_args("cd " .. vim.fn.shellescape(root) .. " && go run .", args)
        end,
    },
    {
        files = { "package.json" },
        cmd = function(root, args)
            local script = "dev"
            local f = io.open(root .. "/package.json")
            if f then
                local ok, decoded = pcall(vim.json.decode, f:read("*a"))
                f:close()
                if ok and decoded.scripts and not decoded.scripts.dev and decoded.scripts.start then
                    script = "start"
                end
            end
            return with_args("cd " .. vim.fn.shellescape(root) .. " && npm run " .. script, args, " -- ")
        end,
    },
    {
        files = { "Makefile" },
        cmd = function(root, args)
            return with_args("cd " .. vim.fn.shellescape(root) .. " && make", args)
        end,
    },
}

function M.detect_project()
    local start = vim.fn.expand("%:p:h")
    local best_entry, best_dir, best_depth

    for _, entry in ipairs(M.project_markers) do
        local found = vim.fs.find(entry.files, {
            upward = true,
            path = start,
        })
        if found[1] then
            local dir = vim.fs.dirname(found[1])
            local depth = select(2, dir:gsub("/", ""))
            if not best_depth or depth > best_depth then
                best_entry, best_dir, best_depth = entry, dir, depth
            end
        end
    end

    return best_entry, best_dir
end

function M.get_command(args)
    args = args or ""

    local entry, root = M.detect_project()
    if entry then
        local ok, result = pcall(entry.cmd, root, args)
        if ok then
            return result
        end
        vim.notify("run.lua: failed to build command: " .. tostring(result), vim.log.levels.ERROR)
        return nil
    end

    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname == "" then
        vim.notify("run.lua: buffer is unsaved, nothing to run", vim.log.levels.WARN)
        return nil
    end

    local command = M.default_commands[vim.bo.filetype]
    if not command then
        return nil
    end
    return command(vim.fn.shellescape(bufname), args)
end

function M.run(run_command)
    if run_command == nil then
        run_command = M.get_command("")
    end
    if not run_command then
        return
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

function M.run_with_args()
    local args = vim.fn.input("Arguments: ")
    if args ~= "" then
        local parts = {}
        for word in args:gmatch("%S+") do
            table.insert(parts, vim.fn.shellescape(word))
        end
        args = table.concat(parts, " ")
    end

    local cmd = M.get_command(args)
    if not cmd then
        return
    end
    M.run(cmd)
end

return M
