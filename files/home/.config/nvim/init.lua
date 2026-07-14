vim.loader.enable()

--[[ STARTUP TIME ]]--
local startup_time = 0
local start = vim.uv.hrtime()
vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = vim.schedule_wrap(function()
        local finish = vim.uv.hrtime()
        startup_time = finish - start
        local time = startup_time / 1e6
        print("Startup Time: " .. time .. "ms")
    end),
})

if vim.g.vscode == 1 then
    require "vscode-nvim"
else
    require "plugins"
    require "core"
end
