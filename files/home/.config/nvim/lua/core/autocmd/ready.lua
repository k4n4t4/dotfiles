-- TODO:
local group = vim.api.nvim_create_augroup("Ready", { clear = true })

local fired = false
local function fire()
    if fired then
        return
    end
    fired = true
    vim.g.ready = true
    print("Fire")
    vim.api.nvim_exec_autocmds("User", { pattern = "Ready", modeline = false })
end

local function is_real_edit_buffer(buf)
    return true
end

vim.api.nvim_create_autocmd("UIEnter", {
    group = group,
    once = true,
    callback = function()
        vim.api.nvim_create_autocmd({ "BufWinEnter", "BufEnter" }, {
            group = group,
            once = true,
            callback = function(ev)
                if is_real_edit_buffer(ev.buf) then
                    vim.schedule(fire)
                end
            end,
        })
    end,
})
