local M = {}

local group = vim.api.nvim_create_augroup("Utils_lsp", { clear = true })

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
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    if not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
    end
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

--- Registers a catch-all FileType autocmd that auto-detects and enables LSP servers
--- installed via Mason (or available on PATH) for each filetype, optionally loading
--- custom configs from `config_path.<server_name>`.
---@param config_path string Lua module prefix for server config files (e.g. "lsp")
function M.auto_set(config_path)
    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = vim.schedule_wrap(function(args)
            if not vim.api.nvim_buf_is_valid(args.buf) or
                vim.api.nvim_get_current_buf() ~= args.buf then
                return
            end

            local installed_servers = {}
            do
                local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
                if ok then
                    installed_servers = mason_lspconfig.get_installed_servers()
                else
                    return
                end
            end

            local servers = {}
            do
                local ok, mason_lspconfig_mappings = pcall(require, "mason-lspconfig.mappings")
                if ok then
                    local filetype_map = mason_lspconfig_mappings.get_filetype_map()
                    servers = filetype_map[args.match] or {}
                end
            end

            for _, server_name in ipairs(servers) do
                if not M.configured[server_name] then
                    local had_custom_config, config = pcall(require, config_path .. "." .. server_name)

                    local installed = vim.tbl_contains(installed_servers, server_name)

                    if not installed then
                        local cmd
                        if had_custom_config and config and config.cmd and #config.cmd > 0 then
                            cmd = config.cmd
                        else
                            local registered = vim.lsp.config[server_name]
                            if registered then
                                if type(registered.cmd) == "table" and #registered.cmd > 0 then
                                    cmd = registered.cmd
                                elseif type(registered.cmd) == "function" then
                                    local ok, result = pcall(registered.cmd)
                                    if ok and type(result) == "table" and #result > 0 then
                                        cmd = result
                                    end
                                end
                            end
                        end
                        if cmd then
                            installed = vim.fn.executable(cmd[1]) == 1
                        end
                    end

                    if installed then
                        if had_custom_config then vim.lsp.config(server_name, config) end
                        vim.lsp.enable(server_name)
                        M.configured[server_name] = true
                    end
                end
            end
        end),
    })
end

return M
