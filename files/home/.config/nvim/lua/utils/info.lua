local M = {}

local group = vim.api.nvim_create_augroup("Utils_info", { clear = true })
local uv = vim.uv or vim.loop


M.cache = {}
local function cached(key, fn)
    if M.cache[key] == nil then
        M.cache[key] = fn()
    end
    return M.cache[key]
end

local function file_exists(path)
    return uv.fs_stat(path) ~= nil
end

local function path_contains(path, target)
    if not path or not target then return false end
    return string.find(path, target, 1, true) ~= nil
end


M.path = {}

--- Returns the current working directory (cached per session).
--- @return string
function M.path.cwd()
    return cached("path_cwd", uv.cwd)
end

--- Returns the Neovim config directory path (cached).
--- @return string
function M.path.config()
    return cached("path_config", function()
        return vim.fn.stdpath("config")
    end)
end

function M.path.stdpath(type)
    return cached("path_stdpath_" .. type, function()
        return vim.fn.stdpath(type)
    end)
end

--- Returns true if the cwd is inside the Neovim config directory (cached).
--- @param path? string Optional path to check (defaults to cwd)
--- @return boolean
function M.path.in_config_dir(path)
    path = path or M.path.cwd()
    return cached("path_in_config_dir", function()
        return path_contains(path, M.path.config())
    end)
end

--- Returns true if the cwd contains "/nvim" in its path (cached).
--- @param path? string Optional path to check (defaults to cwd)
--- @return boolean
function M.path.in_nvim_repo(path)
    path = path or M.path.cwd()
    return cached("path_in_nvim_repo", function()
        return path_contains(path, "/nvim")
    end)
end

--- Returns true if the cwd is in the config dir or a Neovim-related repository (cached).
--- @param path? string Optional path to check (defaults to cwd)
--- @return boolean
function M.path.is_nvim_related(path)
    path = path or M.path.cwd()
    return cached("path_is_nvim_related", function()
        return M.path.in_config_dir(path) or M.path.in_nvim_repo(path)
    end)
end

M.env = {}

--- Returns the OS name (e.g. "Linux", "Darwin") as reported by libuv (cached).
--- @return string
function M.env.os_name()
    return cached("env_os_name", function()
        return uv.os_uname().sysname
    end)
end

--- Returns true if the current OS is Linux (cached).
--- @return boolean
function M.env.is_linux()
    return cached("env_is_linux", function()
        return M.env.os_name() == "Linux"
    end)
end

--- Returns true if running on NixOS (detected via /etc/NIXOS or /run/current-system) (cached).
--- @return boolean
function M.env.is_nixos()
    return cached("env_is_nixos", function()
        return file_exists("/etc/NIXOS")
            or file_exists("/run/current-system")
    end)
end

--- Returns true if running inside a Docker container (cached).
--- @return boolean
function M.env.is_docker()
    return cached("env_is_docker", function()
        return file_exists("/.dockerenv")
            or path_contains(vim.env.container, "docker")
    end)
end

--- Returns true if running inside WSL (Windows Subsystem for Linux) (cached).
--- @return boolean
function M.env.is_wsl()
    return cached("env_is_wsl", function()
        return vim.env.WSL_DISTRO_NAME ~= nil
    end)
end

--- Returns true if Neovim is running as a VSCode extension host (cached).
--- @return boolean
function M.env.is_vscode()
    return cached("env_is_vscode", function()
        return vim.g.vscode == 1
    end)
end

M.buf = {}
M.buf.cache = {}

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = group,
    callback = function(args)
        M.buf.cache[args.buf] = M.buf.cache[args.buf] or {}
        M.buf.cache[args.buf].diagnostics = nil
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        M.buf.cache[args.buf] = M.buf.cache[args.buf] or {}
        M.buf.cache[args.buf].lsp_clients = nil
    end,
})

vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = { "fileformat", "fileencoding", "filetype" },
    callback = function(args)
        local bufnr = vim.api.nvim_get_current_buf()
        if M.buf.cache[bufnr] then
            M.buf.cache[bufnr][args.match] = nil
        end
    end,
})

vim.api.nvim_create_autocmd("BufDelete", {
    group = group,
    callback = function(args)
        M.buf.cache[args.buf] = nil
    end,
})

local function cached_buf(bufnr, key, fn)
    bufnr = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if not vim.api.nvim_buf_is_valid(bufnr) then return nil end

    if not M.buf.cache[bufnr] then M.buf.cache[bufnr] = {} end
    if M.buf.cache[bufnr][key] == nil then
        M.buf.cache[bufnr][key] = fn(bufnr)
    end
    return M.buf.cache[bufnr][key]
end

--- Gets an option value for a buffer.
--- @param bufnr integer Buffer number (0 for current)
--- @param name string Option name
--- @return any
function M.buf.get_opt(bufnr, name)
    return vim.api.nvim_get_option_value(name, { buf = bufnr })
end

--- Returns the filename (tail) of the buffer's path (cached per buffer).
--- @param bufnr integer
--- @return string|nil
function M.buf.name(bufnr)
    return cached_buf(bufnr, "name", function(b)
        local path = vim.api.nvim_buf_get_name(b)
        return path ~= "" and vim.fn.fnamemodify(path, ":t") or path
    end)
end

--- Returns the full path of the buffer (cached per buffer).
--- @param bufnr integer
--- @return string|nil
function M.buf.path(bufnr)
    return cached_buf(bufnr, "path", function(b)
        return vim.api.nvim_buf_get_name(b)
    end)
end

--- Returns the filetype of the buffer (cached per buffer, invalidated on OptionSet).
--- @param bufnr integer
--- @return string|nil
function M.buf.filetype(bufnr)
    return cached_buf(bufnr, "filetype", function(b)
        return M.buf.get_opt(b, "filetype")
    end)
end

--- Returns the buftype of the buffer (cached per buffer). Empty string means a normal file.
--- @param bufnr integer
--- @return string|nil
function M.buf.buftype(bufnr)
    return cached_buf(bufnr, "buftype", function(b)
        return M.buf.get_opt(b, "buftype")
    end)
end

--- Returns the file encoding of the buffer, falling back to `vim.o.encoding` (cached).
--- @param bufnr integer
--- @return string|nil
function M.buf.encoding(bufnr)
    return cached_buf(bufnr, "encoding", function(b)
        local enc = M.buf.get_opt(b, "fileencoding")
        return enc ~= "" and enc or vim.o.encoding
    end)
end

--- Returns the file format of the buffer (e.g. "unix", "dos") (cached).
--- @param bufnr integer
--- @return string|nil
function M.buf.fileformat(bufnr)
    return cached_buf(bufnr, "fileformat", function(b)
        return M.buf.get_opt(b, "fileformat")
    end)
end

--- Returns true if the buffer has unsaved modifications.
--- @param bufnr integer
--- @return boolean
function M.buf.modified(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "modified") or false
end

--- Returns true if the buffer is modifiable.
--- @param bufnr integer
--- @return boolean
function M.buf.is_modifiable(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "modifiable") or false
end

--- Returns true if the buffer is read-only.
--- @param bufnr integer
--- @return boolean
function M.buf.is_readonly(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "readonly") or false
end

--- Returns true if the buffer is a real file (buftype == "").
--- @param bufnr integer
--- @return boolean
function M.buf.is_real_file(bufnr)
    return M.buf.buftype(bufnr) == ""
end

--- Returns true if the buffer is a preview window buffer.
--- @param bufnr integer
--- @return boolean
function M.buf.is_preview(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "previewwindow") or false
end

--- Returns diagnostics for the buffer grouped by severity (cached, invalidated on DiagnosticChanged).
--- @param bufnr integer
--- @return table|nil Table with keys `error`, `warn`, `info`, `hint`
function M.buf.diagnostics(bufnr)
    return cached_buf(bufnr, "diagnostics", function(b)
        if not vim.api.nvim_buf_is_valid(b) then return {} end
        return {
            error = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.ERROR }),
            warn  = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.WARN }),
            info  = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.INFO }),
            hint  = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.HINT }),
        }
    end)
end

--- Returns a list of LSP client names attached to the buffer (cached, invalidated on LspAttach).
--- @param bufnr integer
--- @return table|nil List of client name strings
function M.buf.lsp_clients(bufnr)
    return cached_buf(bufnr, "lsp_clients", function(b)
        local clients = vim.lsp.get_clients({ bufnr = b })
        local names = {}
        for _, client in ipairs(clients) do
            table.insert(names, client.name)
        end
        return names
    end)
end

--- Returns the current search count for the buffer (only for the active buffer with `hlsearch` on).
--- Returns nil if the buffer is not active, hlsearch is off, or there are no matches.
--- @param bufnr integer
--- @return table|nil searchcount result (see `:h searchcount()`)
function M.buf.search_count(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if b ~= vim.api.nvim_get_current_buf() or vim.v.hlsearch == 0 then
        return nil
    end

    local ok, search = pcall(vim.fn.searchcount, { recompute = 1, maxcount = 999, timeout = 100 })
    if not ok or next(search) == nil or search.total == 0 then
        return nil
    end

    return search
end

--- Returns git status for the buffer (head, added, changed, removed), or nil if unavailable.
--- Supports both gitsigns.nvim and mini.git + mini.diff.
--- @param bufnr? integer
--- @return table|nil
function M.buf.git(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if not vim.api.nvim_buf_is_valid(b or 0) then
        return nil
    end

    -- gitsigns.nvim
    local gs = vim.b[b].gitsigns_status_dict
    if gs then
        return {
            head = gs.head,
            added = gs.added,
            changed = gs.changed,
            removed = gs.removed,
        }
    end

    -- mini.git + mini.diff
    local git = vim.b[b].minigit_summary
    local diff = vim.b[b].minidiff_summary
    if git or diff then
        return {
            head = git and git.head_name or nil,
            added = diff and diff.add or 0,
            changed = diff and diff.change or 0,
            removed = diff and diff.delete or 0,
        }
    end

    return nil
end

return M
