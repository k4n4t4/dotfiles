local M = {
    hostname = nil,
    port = nil,
    base_url = nil,
    password = nil,
    server = nil,
}

local function random_password(length)
    local chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local bytes = assert(vim.uv.random(length))
    local result = {}

    for i = 1, length do
        local index = (bytes:byte(i) % #chars) + 1
        result[i] = chars:sub(index, index)
    end

    return table.concat(result)
end

local function parse(out)
    if out.code ~= 0 then
        return nil, out.stderr
    end
    if out.stdout == "" then
        return true
    end
    local ok, data = pcall(vim.json.decode, out.stdout)
    return ok and data or out.stdout
end

local function request(method, path, opts, cb)
    opts = opts or {}
    local cmd = { "opencode", "api", "--server", M.base_url, method, path }
    for k, v in pairs(opts.query or {}) do
        vim.list_extend(cmd, { "--param", k .. "=" .. tostring(v) })
    end
    if opts.body then
        vim.list_extend(cmd, { "--data", vim.json.encode(opts.body) })
    end
    local sys_opts = { text = true, env = { OPENCODE_SERVER_PASSWORD = M.password } }

    if cb then
        vim.system(
            cmd,
            sys_opts,
            vim.schedule_wrap(function(out)
                cb(parse(out))
            end)
        )
    else
        return parse(vim.system(cmd, sys_opts):wait())
    end
end

function M.get(path, query, cb)
    return request("GET", path, { query = query }, cb)
end

function M.delete(path, query, cb)
    return request("DELETE", path, { query = query }, cb)
end

function M.post(path, body, cb)
    return request("POST", path, { body = body }, cb)
end

function M.put(path, body, cb)
    return request("PUT", path, { body = body }, cb)
end

function M.patch(path, body, cb)
    return request("PATCH", path, { body = body }, cb)
end

function M.setup(opts)
    opts = opts or {}
    M.hostname = opts.hostname or "127.0.0.1"
    M.port = opts.port or 4096
    M.base_url = opts.base_url or ("http://%s:%d"):format(M.hostname, M.port)
    M.password = opts.password or random_password(32)
end

function M.on_server_start(callback)
    M._on_server_start = callback
end

local function on_server_start()
    if M._on_server_start then
        M._on_server_start()
    end
end

local function wait_server(tries)
    M.get("/api/info", nil, function(data)
        if data then
            on_server_start()
        elseif tries > 0 then
            vim.defer_fn(function()
                wait_server(tries - 1)
            end, 200)
        end
    end)
end

function M.start_server()
    M.get("/api/info", nil, function(data)
        if data then
            return on_server_start()
        end
        M.server = vim.fn.jobstart({
            "opencode",
            "serve",
            "--hostname",
            M.hostname,
            "--port",
            tostring(M.port),
        }, {
            env = {
                OPENCODE_SERVER_PASSWORD = M.password,
            },
            detach = false,
            on_exit = function()
                M.server = nil
            end,
        })
        wait_server(50)
    end)
end

function M.close_server()
    if M.server and M.server > 0 then
        vim.fn.jobstop(M.server)
    end
end

return M
