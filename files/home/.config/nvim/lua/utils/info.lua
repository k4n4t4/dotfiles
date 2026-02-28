local M = {}

local group = vim.api.nvim_create_augroup("Utils_info", { clear = true })
local uv = vim.uv or vim.loop
local mapping = require("utils.mapping")


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
--- @return boolean
function M.path.in_config_dir()
    return cached("path_in_config_dir", function()
        return path_contains(M.path.cwd(), M.path.config())
    end)
end

--- Returns true if the cwd contains "/nvim" in its path (cached).
--- @return boolean
function M.path.in_nvim_repo()
    return cached("path_in_nvim_repo", function()
        return path_contains(M.path.cwd(), "/nvim")
    end)
end

--- Returns true if the cwd is in the config dir or a Neovim-related repository (cached).
--- @return boolean
function M.path.is_nvim_related()
    return cached("path_is_nvim_related", function()
        return M.path.in_config_dir() or M.path.in_nvim_repo()
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

--- Returns gitsigns status for the buffer (head, added, changed, removed), or nil if unavailable.
--- @param bufnr integer
--- @return table|nil Table with keys `head`, `added`, `changed`, `removed`
function M.buf.gitsigns(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if not vim.api.nvim_buf_is_valid(b) then return nil end

    local status = vim.b[b].gitsigns_status_dict

    if not status then return nil end

    return {
        head    = status.head,
        added   = status.added,
        changed = status.changed,
        removed = status.removed,
    }
end

M.tab = {}
M.tab.cache = {}

vim.api.nvim_create_autocmd({
    "TabClosed", "WinClosed", "WinNew", "TabEnter",
    "WinEnter", "WinLeave", "BufWinEnter", "BufWinLeave"
}, {
    group = group,
    callback = function()
        M.tab.cache = {}
        M.win.cache = {}
    end
})

local function cached_tab(tabnr, key, fn)
    tabnr = (tabnr == 0 or tabnr == nil) and vim.api.nvim_get_current_tabpage() or tabnr
    if not vim.api.nvim_tabpage_is_valid(tabnr) then return nil end

    if not M.tab.cache[tabnr] then M.tab.cache[tabnr] = {} end
    if M.tab.cache[tabnr][key] == nil then
        M.tab.cache[tabnr][key] = fn(tabnr)
    end
    return M.tab.cache[tabnr][key]
end

--- Returns the tab number (1-based) for a tabpage handle (cached).
--- @param tabpage integer Tabpage handle (0 for current)
--- @return integer|nil
function M.tab.number(tabpage)
    return cached_tab(tabpage, "number", function(tp)
        tp = (tp == 0 or tp == nil) and vim.api.nvim_get_current_tabpage() or tp
        return vim.api.nvim_tabpage_get_number(tp)
    end)
end

--- Returns the list of buffer handles currently open in all windows of a tabpage (cached).
--- @param tabpage integer Tabpage handle (0 for current)
--- @return table|nil List of buffer handles
function M.tab.buflist(tabpage)
    return cached_tab(tabpage, "buflist", function(tp)
        tp = (tp == 0 or tp == nil) and vim.api.nvim_get_current_tabpage() or tp
        if not vim.api.nvim_tabpage_is_valid(tp) then return {} end

        local wins = vim.api.nvim_tabpage_list_wins(tp)
        local bufs = {}
        for _, win in ipairs(wins) do
            table.insert(bufs, vim.api.nvim_win_get_buf(win))
        end
        return bufs
    end)
end

--- Returns the buffer handle of the focused window in a tabpage (cached).
--- @param tabpage integer Tabpage handle (0 for current)
--- @return integer|nil Buffer handle
function M.tab.active_buf(tabpage)
    return cached_tab(tabpage, "active_buf", function(tp)
        tp = (tp == 0 or tp == nil) and vim.api.nvim_get_current_tabpage() or tp
        if not vim.api.nvim_tabpage_is_valid(tp) then return nil end

        local win = vim.api.nvim_tabpage_get_win(tp)
        return vim.api.nvim_win_get_buf(win)
    end)
end

--- Returns true if any buffer in the tabpage has unsaved modifications (cached).
--- @param tabpage integer Tabpage handle (0 for current)
--- @return boolean|nil
function M.tab.is_modified(tabpage)
    return cached_tab(tabpage, "is_modified", function(tp)
        local bufs = M.tab.buflist(tp) or {}
        for _, bufnr in ipairs(bufs) do
            if M.buf.modified(bufnr) then return true end
        end
        return false
    end)
end

M.win = {}
M.win.cache = {}

local function cached_win(winnr, key, fn)
    winnr = (winnr == 0 or winnr == nil) and vim.api.nvim_get_current_win() or winnr
    if not vim.api.nvim_win_is_valid(winnr) then return nil end

    if not M.win.cache[winnr] then M.win.cache[winnr] = {} end
    if M.win.cache[winnr][key] == nil then
        M.win.cache[winnr][key] = fn(winnr)
    end
    return M.win.cache[winnr][key]
end

--- Returns the buffer handle displayed in a window (cached).
--- @param winnr integer Window handle (0 for current)
--- @return integer|nil
function M.win.buf(winnr)
    return cached_win(winnr, "buf", function(w)
        return vim.api.nvim_win_get_buf(w)
    end)
end

--- Returns the width of a window in columns (cached).
--- @param winnr integer Window handle (0 for current)
--- @return integer|nil
function M.win.width(winnr)
    return cached_win(winnr, "width", function(w)
        return vim.api.nvim_win_get_width(w)
    end)
end

--- Returns the height of a window in rows (cached).
--- @param winnr integer Window handle (0 for current)
--- @return integer|nil
function M.win.height(winnr)
    return cached_win(winnr, "height", function(w)
        return vim.api.nvim_win_get_height(w)
    end)
end

--- Returns true if the window is a floating window (cached).
--- @param winnr integer Window handle (0 for current)
--- @return boolean|nil
function M.win.is_float(winnr)
    return cached_win(winnr, "is_float", function(w)
        local config = vim.api.nvim_win_get_config(w)
        return config.relative ~= ""
    end)
end

--- Returns the cursor position in a window as `{row, col}` (not cached).
--- @param winnr integer Window handle (0 for current)
--- @return { row: integer, col: integer }|nil
function M.win.cursor(winnr)
    local w = (winnr == 0 or winnr == nil) and vim.api.nvim_get_current_win() or winnr
    if not vim.api.nvim_win_is_valid(w) then return nil end
    local pos = vim.api.nvim_win_get_cursor(w)
    return { row = pos[1], col = pos[2] }
end

--- Returns the top-left screen position of a window as `{row, col}` (cached).
--- @param winnr integer Window handle (0 for current)
--- @return { row: integer, col: integer }|nil  top-left position on screen
function M.win.position(winnr)
    return cached_win(winnr, "position", function(w)
        local pos = vim.api.nvim_win_get_position(w)
        return { row = pos[1], col = pos[2] }
    end)
end

M.state = {}
M.state.cache = {}

vim.api.nvim_create_autocmd("ModeChanged", {
    group = group,
    callback = function()
        M.state.cache = {}
    end,
})

local function cached_state(key, fn)
    if M.state.cache[key] == nil then
        M.state.cache[key] = fn()
    end
    return M.state.cache[key]
end

--- Returns the name of the register currently being recorded to, or "" if not recording.
--- @return string Register name (e.g. "q"), or ""
function M.state.macro()
    return vim.fn.reg_recording()
end

--- Returns true if a macro is currently being recorded.
--- @return boolean
function M.state.is_recording()
    return vim.fn.reg_recording() ~= ""
end

--- Returns the contents of a named register.
--- @param reg string Register name (e.g. "a", "+", "*")
--- @return string Register contents
function M.state.get_register(reg)
    return vim.fn.getreg(reg)
end

--- Returns the pending operator count (v:count), or 0 if none.
--- @return integer
function M.state.count()
    return vim.v.count
end

M.state.mode = {}

--- Returns the raw mode string from nvim_get_mode() (cached, invalidated on ModeChanged).
--- @return string
function M.state.mode.raw()
    return cached_state("mode_raw", function()
        return vim.api.nvim_get_mode().mode
    end)
end

--- Returns true if the current mode is Normal (including operator-pending variants).
--- @return boolean
function M.state.mode.is_normal()
    return cached_state("mode_is_normal", function()
        return vim.startswith(M.state.mode.raw(), "n")
    end)
end

--- Returns true if the current mode is Insert.
--- @return boolean
function M.state.mode.is_insert()
    return cached_state("mode_is_insert", function()
        return vim.startswith(M.state.mode.raw(), "i")
    end)
end

--- Returns true if the current mode is any Visual mode (char, line, or block).
--- @return boolean
function M.state.mode.is_visual()
    return cached_state("mode_is_visual", function()
        local m = M.state.mode.raw()
        return m == "v" or m == "V" or m == "\22"
    end)
end

--- Returns true if the current mode is Replace or Virtual Replace.
--- @return boolean
function M.state.mode.is_replace()
    return cached_state("mode_is_replace", function()
        return vim.startswith(M.state.mode.raw(), "R")
    end)
end

--- Returns true if the current mode is Command-line.
--- @return boolean
function M.state.mode.is_command()
    return cached_state("mode_is_command", function()
        return vim.startswith(M.state.mode.raw(), "c")
    end)
end

--- Returns true if the current mode is Terminal.
--- @return boolean
function M.state.mode.is_terminal()
    return cached_state("mode_is_terminal", function()
        return vim.startswith(M.state.mode.raw(), "t")
    end)
end

--- Returns true if the current mode is Select (char, line, or block).
--- @return boolean
function M.state.mode.is_select()
    return cached_state("mode_is_select", function()
        local m = M.state.mode.raw()
        return m == "s" or m == "S" or m == "\19"
    end)
end

--- Returns a short abbreviated name for the current mode (cached).
--- Uses `utils.mapping.mode` — e.g. "N", "I", "VB".
--- @return string
function M.state.mode.name()
    return cached_state("mode_name", function()
        return mapping.mode.get(M.state.mode.raw()).name
    end)
end

--- Returns a long human-readable label for the current mode (cached).
--- Uses `utils.mapping.mode` — e.g. "NORMAL", "INSERT", "V-BLOCK".
--- @return string
function M.state.mode.label()
    return cached_state("mode_label", function()
        return mapping.mode.get(M.state.mode.raw()).label
    end)
end

return M
