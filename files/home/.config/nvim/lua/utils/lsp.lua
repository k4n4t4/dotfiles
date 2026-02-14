local M = {}

local group = vim.api.nvim_create_augroup("Utils_lsp", { clear = true })

function M.get_null_ls_sources()
    local sources = require "null-ls.sources"
    local availables = {}
    for _, available in pairs(sources.get_available(vim.bo.filetype)) do
        table.insert(availables, available.name)
    end
    return availables
end


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


M.configured = {}

---@alias LspRule { [1]: string|string[], [2]: string }
---@param config_path string
---@param lsp_rules LspRule[]
function M.set(config_path, lsp_rules)
    for _, rule in ipairs(lsp_rules) do
        local pattern, server_name = rule[1], rule[2]

        vim.api.nvim_create_autocmd("FileType", {
            group = group;
            pattern = pattern;
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
            end);
        })
    end
end

---@param config_path string
function M.auto_set(config_path)
    vim.api.nvim_create_autocmd("FileType", {
        group = group;
        pattern = "*";
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
                else
                    return
                end
            end

            for _, server_name in ipairs(servers) do
                if not M.configured[server_name] then
                    local installed = vim.tbl_contains(installed_servers, server_name)

                    local had_custom_config, config = pcall(require, config_path .. "." .. server_name)
                    if had_custom_config
                        and (not installed)
                        and config
                        and config.cmd
                        and #config.cmd > 0
                    then
                        installed = installed or vim.fn.executable(config.cmd[1]) == 1
                    end

                    if installed then
                        if had_custom_config then vim.lsp.config(server_name, config) end
                        vim.lsp.enable(server_name)
                        M.configured[server_name] = true
                    end
                end
            end
        end);
    })
end


return M
