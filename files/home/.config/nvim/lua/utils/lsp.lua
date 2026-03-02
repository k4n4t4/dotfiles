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
local function build_cache()
    M.ft_to_servers_cache = {}

    local server_files = vim.api.nvim_get_runtime_file("lua/lspconfig/configs/*.lua", true)

    for _, file in ipairs(server_files) do
        local server_name = vim.fn.fnamemodify(file, ":t:r")
        local ok, mod = pcall(require, "lspconfig.configs." .. server_name)

        if ok and mod.default_config then
            local filetypes = mod.default_config.filetypes
            if filetypes then
                for _, ft in ipairs(filetypes) do
                    if not M.ft_to_servers_cache[ft] then
                        M.ft_to_servers_cache[ft] = {}
                    end
                    table.insert(M.ft_to_servers_cache[ft], { name = server_name, default_config = mod.default_config})
                end
            end
        end
    end

    local compiled = compiler.compile_table(M.ft_to_servers_cache)
    if not compiled then return nil end

    return fs.write(M.ft_to_servers_cache_filepath, compiled)
end

function M.ft_to_servers(ft)
    if not M.ft_to_servers_cache then
        M.ft_to_servers_cache = compiler.load(M.ft_to_servers_cache_filepath)

        if not M.ft_to_servers_cache then
            build_cache()
        end
    end

    return M.ft_to_servers_cache[ft] or {}
end


M.configured = {}

--- Registers FileType autocmds to lazily load and enable LSP servers based on explicit rules.
--- Each rule maps one or more filetypes to a server name; the server config is loaded
--- from `config_path.<server_name>` on first FileType match.
---@alias LspRule { [1]: string|string[], [2]: string }
---@param config_path string Lua module prefix for server config files (e.g. "lsp")
---@param lsp_rules LspRule[] List of {filetype_pattern, server_name} rules
function M.set(config_path, lsp_rules)
    for _, rule in ipairs(lsp_rules) do
        local pattern, server_name = rule[1], rule[2]

        vim.api.nvim_create_autocmd("FileType", {
            group = group,
            pattern = pattern,
            callback = vim.schedule_wrap(function(args)
                if not vim.api.nvim_buf_is_valid(args.buf) or
                    vim.api.nvim_get_current_buf() ~= args.buf then
                    return
                end
                if not M.configured[server_name] then
                    local ok, config = pcall(require, config_path .. "." .. server_name)
                    if ok then
                        vim.lsp.config(server_name, config)
                        vim.lsp.enable(server_name)
                        M.configured[server_name] = true
                    end
                end
            end),
        })
    end
end

---@param config_path string Lua module prefix for server config files (e.g. "lsp")
---@param opts? { exclude?: string[] } Optional settings; `exclude` lists server names to skip
function M.auto_set(config_path, opts)
    local exclude = opts and opts.exclude or {}
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = vim.schedule_wrap(vim.schedule_wrap(function(args)
            if not vim.api.nvim_buf_is_valid(args.buf) or
                vim.api.nvim_get_current_buf() ~= args.buf then
                return
            end

            local servers = M.ft_to_servers(args.match)
            for _, server in ipairs(servers) do
                local server_name = server.name
                if not M.configured[server_name] and
                    not vim.tbl_contains(exclude, server_name) then
                    local ok, config = pcall(require, config_path .. "." .. server_name)
                    if not ok then config = server.default_config end
                    if vim.fn.executable(config.cmd[1]) == 1 then
                        if ok then vim.lsp.config(server_name, config) end
                        vim.lsp.enable(server_name)
                        M.configured[server_name] = true
                    end
                end
            end
        end)),
    })
end

return M
