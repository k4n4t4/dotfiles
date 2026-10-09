local api = require "plugins.config.sidekick.opencode.api"

api.setup { password = vim.env.OPENCODE_SERVER_PASSWORD or nil }
api.on_server_start(function()
    vim.notify("OpenCode server started", vim.log.levels.INFO, { title = "Sidekick" })
end)
api.start_server()
vim.api.nvim_create_autocmd("VimLeavePre", { callback = api.close_server })

require("plugins.config.sidekick.opencode.override").setup(api)

local env = "OPENCODE_SERVER_PASSWORD=" .. api.password
local ready = ("%s opencode api --server %s GET /api/info >/dev/null 2>&1"):format(env, api.base_url)
local tui = ("%s exec opencode --server %s"):format(env, api.base_url)

return {
    cmd = { "sh", "-c", ("until %s; do sleep 0.2; done; %s"):format(ready, tui) },
}
