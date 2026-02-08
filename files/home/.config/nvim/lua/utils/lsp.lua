local M = {}


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

---@alias LspRule { [1]: string|string[], [2]: string }
---@param config_path string
---@param lsp_rules LspRule[]
function M.set(config_path, lsp_rules)
    local configured = {}

    for _, rule in ipairs(lsp_rules) do
        local pattern, server_name = rule[1], rule[2]

        vim.api.nvim_create_autocmd("FileType", {
            pattern = pattern,
            callback = function()
                if not configured[server_name] then
                    local ok, config = pcall(require, config_path .. "." .. server_name)
                    if ok then
                        vim.lsp.config(server_name, config)
                        configured[server_name] = true
                    end
                end

                vim.lsp.enable(server_name)
            end,
        })
    end
end


return M
