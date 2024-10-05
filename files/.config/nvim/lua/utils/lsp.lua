local M = {}

---@param bufnr number
function M.get(bufnr)
  local clients = {}
  for _, client in pairs(vim.lsp.get_clients { bufnr = bufnr }) do
    if client.name == "null-ls" then
      local sources = {}
      for _, source in pairs(require("null-ls.sources").get_available(vim.bo.filetype)) do
        table.insert(sources, source.name)
      end
      table.insert(clients, "null-ls(" .. table.concat(sources, ", ") .. ")")
    else
      table.insert(clients, client.name)
    end
  end
  return clients
end

return M
