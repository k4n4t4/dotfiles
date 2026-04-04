local group = vim.api.nvim_create_augroup("Settings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


-- highlight yank area
autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank { hlgroup = "Visual", timeout = 150 }
    end,
})

-- fcitx5
vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = vim.schedule_wrap(function()
        if vim.fn.executable("fcitx5") == 1 then
            vim.api.nvim_create_autocmd("InsertLeave", {
                group = vim.api.nvim_create_augroup("fcitx5", { clear = true }),
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
    group = group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})


-- User DirEnter
vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("DirEnter", { clear = true }),
    callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        local stat = vim.uv.fs_stat(bufname)
        if stat and stat.type == "directory" then
            vim.api.nvim_exec_autocmds("User", { pattern = "DirEnter", modeline = false })
        end
    end,
})

-- User BufFirstRead
vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = vim.schedule_wrap(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "BufFirstRead", modeline = false })
    end),
})

-- User Safe
vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = vim.schedule_wrap(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "Safe", modeline = false })
    end),
})

-- User Ready
vim.api.nvim_create_autocmd("UIEnter", {
    once = true,
    callback = vim.schedule_wrap(vim.schedule_wrap(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "Ready", modeline = false })
    end)),
})

-- unlist some filetypes and map q to close
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "help",
        "man",
        "lspinfo",
        "checkhealth",
        "qf",
        "query",
        "scratch",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- User FileTypeAfter
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        vim.api.nvim_create_autocmd("SafeState", {
            once = true,
            callback = function()
                if vim.api.nvim_buf_is_valid(args.buf) then
                    vim.api.nvim_exec_autocmds("User", {
                        pattern = "FileTypeAfter",
                        data = args,
                    })
                end
            end
        })
    end,
})

vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    callback = function()
        require("utils.project_config").setup()
    end,
})
