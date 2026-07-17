local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- highlight yank area
autocmd("TextYankPost", {
    group = augroup("TextYankPost", { clear = true }),
    callback = function()
        vim.highlight.on_yank { hlgroup = "Visual", timeout = 150 }
    end,
})

-- fcitx5
autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = vim.schedule_wrap(function()
        if vim.fn.executable("fcitx5") == 1 then
            autocmd({ "InsertLeave", "CmdlineLeave" }, {
                group = augroup("fcitx5", { clear = true }),
                callback = function()
                    local out = vim.fn.system { "fcitx5-remote" }
                    if out == "2\n" then
                        vim.fn.system { "fcitx5-remote", "-c" }
                    end
                end,
            })
        end
    end),
})

-- restore cursor position
autocmd("BufReadPost", {
    group = augroup("RestoreCursorPosition", { clear = true }),
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- toggle relative number
local group = augroup("toggle_relative_number", { clear = true })

autocmd("InsertEnter", {
    group = group,
    callback = function()
        ---@diagnostic disable-next-line: undefined-field
        if vim.opt_local.number:get() then
            vim.opt_local.relativenumber = false
        end
    end,
})

autocmd("InsertLeave", {
    group = group,
    callback = function()
        ---@diagnostic disable-next-line: undefined-field
        if vim.opt_local.number:get() then
            vim.opt_local.relativenumber = true
        end
    end,
})

-- hide line number
autocmd("FileType", {
    group = augroup("hide_line_number", { clear = true }),
    pattern = { "help", "startify", "dashboard", "snacks_dashboard", "packer", "neogitstatus", "man" },
    callback = function()
        vim.opt_local.number = false
        vim.opt_local.relativenumber = false
        vim.opt_local.signcolumn = "no"
        vim.opt_local.foldcolumn = "0"
    end,
})
