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

function M.path.cwd()
    return cached("path_cwd", uv.cwd)
end

function M.path.config()
    return cached("path_config", function()
        return vim.fn.stdpath("config")
    end)
end

function M.path.in_config_dir()
    return cached("path_in_config_dir", function()
        return path_contains(M.path.cwd(), M.path.config())
    end)
end

function M.path.in_nvim_repo()
    return cached("path_in_nvim_repo", function()
        return path_contains(M.path.cwd(), "/nvim")
    end)
end

function M.path.is_nvim_related()
    return cached("path_is_nvim_related", function()
        return M.path.in_config_dir() or M.path.in_nvim_repo()
    end)
end


M.env = {}

function M.env.os_name()
    return cached("env_os_name", function()
        return vim.loop.os_uname().sysname
    end)
end

function M.env.is_linux()
    return cached("env_is_linux", function()
        return M.env.os_name() == "Linux"
    end)
end

function M.env.is_nixos()
    return cached("env_is_nixos", function()
        return file_exists("/etc/NIXOS")
            or file_exists("/run/current-system")
    end)
end

function M.env.is_docker()
    return cached("env_is_docker", function()
        return file_exists("/.dockerenv")
            or path_contains(vim.env.container, "docker")
    end)
end

function M.env.is_wsl()
    return cached("env_is_wsl", function()
        return vim.env.WSL_DISTRO_NAME ~= nil
    end)
end

function M.env.is_vscode()
    return cached("env_is_vscode", function()
        return vim.g.vscode == 1
    end)
end


M.buf = {}
M.buf.cache = {}

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = group;
    callback = function(args)
        M.buf.cache[args.buf] = M.buf.cache[args.buf] or {}
        M.buf.cache[args.buf].diagnostics = nil
    end;
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = group;
    callback = function(args)
        M.buf.cache[args.buf] = M.buf.cache[args.buf] or {}
        M.buf.cache[args.buf].lsp_clients = nil
    end;
})

vim.api.nvim_create_autocmd("OptionSet", {
    group = group;
    pattern = { "fileformat", "fileencoding", "filetype" },
    callback = function(args)
        local bufnr = vim.api.nvim_get_current_buf()
        if M.buf.cache[bufnr] then
            M.buf.cache[bufnr][args.match] = nil
        end
    end;
})

vim.api.nvim_create_autocmd("BufDelete", {
    group = group;
    callback = function(args)
        M.buf.cache[args.buf] = nil
    end;
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

function M.buf.get_opt(bufnr, name)
    return vim.api.nvim_get_option_value(name, { buf = bufnr })
end

function M.buf.name(bufnr)
    return cached_buf(bufnr, "name", function(b)
        local path = vim.api.nvim_buf_get_name(b)
        return path ~= "" and vim.fn.fnamemodify(path, ":t") or "[No Name]"
    end)
end

function M.buf.path(bufnr)
    return cached_buf(bufnr, "path", function(b)
        return vim.api.nvim_buf_get_name(b)
    end)
end

function M.buf.filetype(bufnr)
    return cached_buf(bufnr, "filetype", function(b)
        return M.buf.get_opt(b, "filetype")
    end)
end

function M.buf.buftype(bufnr)
    return cached_buf(bufnr, "buftype", function(b)
        return M.buf.get_opt(b, "buftype")
    end)
end

function M.buf.encoding(bufnr)
    return cached_buf(bufnr, "encoding", function(b)
        local enc = M.buf.get_opt(b, "fileencoding")
        return enc ~= "" and enc or vim.o.encoding
    end)
end

function M.buf.fileformat(bufnr)
    return cached_buf(bufnr, "fileformat", function(b)
        return M.buf.get_opt(b, "fileformat")
    end)
end

function M.buf.modified(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "modified") or false
end

function M.buf.is_modifiable(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "modifiable") or false
end

function M.buf.is_readonly(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "readonly") or false
end

function M.buf.is_real_file(bufnr)
    return M.buf.buftype(bufnr) == ""
end

function M.buf.is_preview(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "previewwindow") or false
end

function M.buf.diagnostics(bufnr)
    return cached_buf(bufnr, "diagnostics", function(b)
        if not vim.api.nvim_buf_is_valid(b) then return {} end
        return {
            error = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.ERROR });
            warn  = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.WARN });
            info  = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.INFO });
            hint  = vim.diagnostic.get(b, { severity = vim.diagnostic.severity.HINT });
        }
    end)
end

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

function M.buf.gitsigns(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if not vim.api.nvim_buf_is_valid(b) then return nil end

    local status = vim.b[b].gitsigns_status_dict

    if not status then return nil end

    return {
        head   = status.head;
        added  = status.added;
        changed = status.changed;
        removed = status.removed;
    }
end


M.tab = {}
M.tab.cache = {}

vim.api.nvim_create_autocmd("TabClosed", {
    group = group,
    callback = function()
        M.tab.cache = {}
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

function M.tab.number(tabpage)
    local tp = (tabpage == 0 or tabpage == nil) and vim.api.nvim_get_current_tabpage() or tabpage
    return vim.api.nvim_tabpage_get_number(tp)
end

function M.tab.buflist(tabpage)
    local tp = (tabpage == 0 or tabpage == nil) and vim.api.nvim_get_current_tabpage() or tabpage
    if not vim.api.nvim_tabpage_is_valid(tp) then return {} end

    local wins = vim.api.nvim_tabpage_list_wins(tp)
    local bufs = {}
    for _, win in ipairs(wins) do
        table.insert(bufs, vim.api.nvim_win_get_buf(win))
    end
    return bufs
end

function M.tab.active_buf(tabpage)
    local tp = (tabpage == 0 or tabpage == nil) and vim.api.nvim_get_current_tabpage() or tabpage
    if not vim.api.nvim_tabpage_is_valid(tp) then return nil end

    local win = vim.api.nvim_tabpage_get_win(tp)
    return vim.api.nvim_win_get_buf(win)
end

function M.tab.is_modified(tabpage)
    local bufs = M.tab.buflist(tabpage)
    for _, bufnr in ipairs(bufs) do
        if M.buf.modified(bufnr) then return true end
    end
    return false
end


M.edit = {}

function M.edit.macro()
    local reg = vim.fn.reg_recording()
    if reg == "" then
        return ""
    end
    return reg
end

function M.edit.get_register(reg)
    return vim.fn.getreg(reg)
end

return M
