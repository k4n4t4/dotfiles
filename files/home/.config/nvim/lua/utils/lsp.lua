local M = {}

local compiler = require("utils.compiler")
local info = require("utils.info")
local fs = require("utils.fs")

local group = vim.api.nvim_create_augroup("Utils_lsp", { clear = true })


function M.hover(opts)
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result)
        if not (result and result.contents) then return end
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        if vim.tbl_isempty(markdown_lines) then return end
        local _, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", opts or {})

        if opts and opts.winblend then
            vim.wo[winid].winblend = opts.winblend
        end
    end)
end

function M.signature_help(opts)
    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, "textDocument/signatureHelp", params, function(_, result)
        if not (result) then return end
        local markdown_lines = vim.lsp.util.convert_signature_help_to_markdown_lines(result, vim.bo.filetype) or {}
        if vim.tbl_isempty(markdown_lines) then return end
        local _, winid = vim.lsp.util.open_floating_preview(markdown_lines, "markdown", opts or {})

        if opts and opts.winblend then
            vim.wo[winid].winblend = opts.winblend
        end
    end)
end

--- Returns a list of available null-ls source names for the current buffer's filetype.
--- @return string[] List of null-ls source names
function M.get_null_ls_sources()
    local sources = require "null-ls.sources"
    local availables = {}
    for _, available in pairs(sources.get_available(vim.bo.filetype)) do
        table.insert(availables, available.name)
    end
    return availables
end

--- Returns active LSP client names and null-ls sources for a buffer.
---@param bufnr number
---@return string[], table<string, string[]>
function M.get(bufnr)
    local clients = {}
    local others = {}
    for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
        if client.name == "null-ls" then
            others["null-ls"] = M.get_null_ls_sources()
        else
            table.insert(clients, client.name)
        end
    end
    return clients, others
end

--- Adds the Mason bin directory to PATH if it is not already present.
function M.add_mason_bin_path()
    local mason_bin = info.path.stdpath("data") .. "/mason/bin"
    if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
    end
end

M.ft_to_servers_cache_filepath = info.path.stdpath("cache") .. "/utils/lsp/lsp_ft_servers_cache.lua"
M.ft_to_servers_cache = nil
M.ft_to_servers_get_cache = false

function M.server_to_config(server_name)
    local ok, config = pcall(require, "lspconfig.configs." .. server_name)
    if ok and config.default_config then return config.default_config end
    return nil
end

local function build_ft_servers_cache()
    if not pcall(require, "lspconfig") then return end

    local cache = {}

    local server_files = vim.api.nvim_get_runtime_file("lsp/*.lua", true)

    for _, file in ipairs(server_files) do
        local server_name = vim.fn.fnamemodify(file, ":t:r")
        local ok, mod = pcall(require, "lspconfig.configs." .. server_name)

        if ok and mod.default_config then
            local filetypes = mod.default_config.filetypes
            if filetypes then
                for _, ft in ipairs(filetypes) do
                    if not cache[ft] then cache[ft] = {} end

                    table.insert(cache[ft], server_name)
                end
            end
        end
    end

    local compiled = compiler.compile_table(cache)
    if not compiled then return nil end

    fs.write(M.ft_to_servers_cache_filepath, compiled)

    return cache
end

function M.ft_to_servers(ft)
    if not M.ft_to_servers_get_cache then
        local cache = compiler.load(M.ft_to_servers_cache_filepath)
        if not cache then cache = build_ft_servers_cache() end
        M.ft_to_servers_get_cache = true
        M.ft_to_servers_cache = vim.tbl_extend("keep", (M.ft_to_servers_cache or {}), cache)
    end

    return M.ft_to_servers_cache[ft] or {}
end

function M.register_ft_servers(ft, servers)
    M.ft_to_servers_cache = M.ft_to_servers_cache or {}
    M.ft_to_servers_cache[ft] = servers
end

local wrapper_executables = {
    python = true,
    python3 = true,
    python2 = true,
    node = true,
    npx = true,
    ruby = true,
    perl = true,
    dotnet = true,
    java = true,
    julia = true,
    R = true,
    coursier = true,
    pwsh = true,
}

-- Flags whose next argument is inline code, not a file or module name.
local code_flags = { ['-e'] = true, ['-c'] = true, ['-Command'] = true }

--- Checks if a Ruby gem binstub has its gem actually installed.
--- Ruby may ship binstubs for gems that aren't present (e.g. typeprof via Nix).
---@param exe_path string Absolute path to the executable
---@param gem_name string The gem name to check
---@return boolean|nil true/false if Ruby binstub, nil otherwise
local function check_ruby_gem(exe_path, gem_name)
    local f = io.open(exe_path, "r")
    if not f then return nil end
    local shebang = f:read("*l") or ""
    f:close()
    if not shebang:match("ruby") then return nil end
    local interp = shebang:match("^#!%s*(%S+)")
    if not interp then return nil end
    if vim.fn.fnamemodify(interp, ":t") == "env" then
        interp = shebang:match("^#!%s*%S+%s+(%S+)")
    end
    if not interp or vim.fn.executable(interp) ~= 1 then return nil end
    vim.fn.system({ interp, "-e", "gem '" .. gem_name .. "', '>= 0.a'" })
    return vim.v.shell_error == 0
end

-- Wrappers whose first non-flag argument is a subcommand, not a program to run.
local subcommand_wrappers = { coursier = true }

--- Checks if an LSP server command is actually available.
--- Handles wrapper commands (python, npx, node, etc.) with flag-aware logic:
---   - `python -m module`: verifies the module is importable via the same interpreter.
---   - `perl -MModule`: verifies the Perl module is loadable.
---   - `-e`/`-c`/`-Command` (inline code): returns true if the interpreter is available,
---     since package availability cannot be verified without execution.
---   - Subcommand wrappers (coursier): only require the wrapper to be executable.
---   - Other non-flag args: checked as executable or existing file path.
--- For standalone executables, also detects Ruby gem binstubs and verifies gem availability.
---@param cmd string[]?
---@return boolean
function M.is_cmd_available(cmd)
    if not cmd or #cmd == 0 then return false end

    local bin = vim.fn.fnamemodify(cmd[1], ":t")

    if not wrapper_executables[bin] then
        if vim.fn.executable(cmd[1]) ~= 1 then return false end
        local exe_path = vim.fn.exepath(cmd[1])
        if exe_path ~= "" then
            local gem_ok = check_ruby_gem(exe_path, bin)
            if gem_ok ~= nil then return gem_ok end
        end
        return true
    end

    if vim.fn.executable(cmd[1]) ~= 1 then return false end
    if #cmd < 2 then return false end

    if subcommand_wrappers[bin] then return true end

    local i = 2
    while i <= #cmd do
        local arg = cmd[i]
        if code_flags[arg] then
            -- -e/-c/-Command: next arg is inline code.
            -- Can't verify package availability; interpreter being present is sufficient.
            return true
        elseif arg == '-m' and bin:match('^python') then
            -- python -m module: verify the module is importable
            if i + 1 <= #cmd then
                vim.fn.system({ cmd[1], '-c', 'import ' .. cmd[i + 1] })
                return vim.v.shell_error == 0
            end
            return false
        elseif arg:match('^%-M') and bin == 'perl' then
            -- perl -MModule::Name: verify the module is loadable
            local module = arg:sub(3):match('^[^=]+')
            if module and module ~= '' then
                vim.fn.system({ cmd[1], '-e', 'use ' .. module })
                return vim.v.shell_error == 0
            end
        elseif not arg:match("^%-") then
            return vim.fn.executable(arg) == 1 or vim.uv.fs_stat(arg) ~= nil
        end
        i = i + 1
    end

    return false
end

M.configured = {}

function M.auto_set()
    vim.api.nvim_create_autocmd("User", {
        pattern = "FileTypeAfter",
        callback = vim.schedule_wrap(function(args)
            local ft = args.data.match
            if M.configured[ft] then return end

            local servers = M.ft_to_servers(ft)

            for _, name in ipairs(servers) do
                if vim.lsp.config[name] and M.is_cmd_available(vim.lsp.config[name].cmd) then
                    vim.lsp.enable(name)
                end
                M.configured[ft] = true
            end
        end),
    })
end

return M
