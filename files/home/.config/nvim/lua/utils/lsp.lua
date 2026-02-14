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

function M.auto_set()
    vim.api.nvim_create_autocmd("FileType", {
        group = group;
        pattern = "*";
        callback = vim.schedule_wrap(function(args)
            local filetype_map = require("mason-lspconfig.mappings").get_filetype_map()
            local ft = args.match
            local servers = filetype_map[ft] or {}
            local installed = require("mason-lspconfig").get_installed_servers()
            print("Available servers for " .. ft .. " count: " .. #servers)
            for _, server in ipairs(servers) do
                print("Checking " .. server .. " for " .. ft)
                if vim.tbl_contains(installed, server) then
                    print(server .. " is available for " .. ft)
                    vim.lsp.enable(server)
                end
            end
        end);
    })
end


return M
