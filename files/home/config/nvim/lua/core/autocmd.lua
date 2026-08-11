local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup


-- highlight on yank
autocmd("TextYankPost", {
    group = augroup("TextYankPost", { clear = true }),
    callback = function()
        vim.highlight.on_yank { hlgroup = "Visual", timeout = 150 }
    end,
})

-- disable fcitx5 when leaving insert mode
autocmd("SafeState", {
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

-- hide line number for certain filetypes
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

-- treesitter
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(_)
        local ok, _ = pcall(vim.treesitter.start)
        if ok then
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldtext = ""
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end
    end,
})

-- LSP attach notification
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("LspAttachNotify", { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
            vim.notify("LSP Attached: " .. client.name, vim.log.levels.INFO)
        end
    end,
})
