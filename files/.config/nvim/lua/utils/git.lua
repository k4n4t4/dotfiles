local M = {}

M.data = {}

---@param bufnr number
---@param callback? fun(data: any)
function M.update(bufnr, callback)
  M.data[bufnr] = M.data[bufnr] or {}

  local cwd = vim.fn.expand("%:h")

  local system_promises = {
    {
      cmd = { "git", "rev-parse", "--abbrev-ref", "@" },
      opts = {
        cwd = cwd,
        stderr = false,
        timeout = 5000,
      },
      on_exit = function(obj)
        if obj.code == 0 then
          M.data[bufnr].branch = obj.stdout
        end
      end,
    },
  }

  local count = #system_promises
  for _, system in pairs(system_promises) do
    vim.system(system.cmd, system.opts, function(obj)
      system.on_exit(obj)
      count = count - 1
      if count == 0 then
        if callback then
          callback(M.data[bufnr])
        end
      end
    end)
  end
end

function M.get(bufnr)
  return M.data[bufnr]
end

M.update(0, function(data)
  print(data.branch)
end)

return M
