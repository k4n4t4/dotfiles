local M = {}

function M.float_input(opts)
    opts = vim.tbl_deep_extend("force", {
        filetype = "text",
        on_submit = function(_) end,
        on_cancel = function() end,
        on_create = function(_) end,
        win = {
            title = "Input",
            relative = "editor",
            width = math.floor(vim.o.columns * 0.6),
            height = 5,
            style = "minimal",
            border = "rounded",
        },
    }, opts or {})

    opts.win = vim.tbl_extend("force", {
        row = math.floor((vim.o.lines - opts.win.height) / 2),
        col = math.floor((vim.o.columns - opts.win.width) / 2),
    }, opts.win)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, "input://" .. buf)
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].filetype = opts.filetype

    local win = vim.api.nvim_open_win(buf, true, opts.win)
    local submitted = false

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    local function submit()
        submitted = true
        vim.bo[buf].modified = false
        local msg = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
        close()
        opts.on_submit(msg)
    end

    vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(win),
        once = true,
        callback = function()
            if not submitted then
                opts.on_cancel()
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufModifiedSet", {
        buffer = buf,
        callback = function()
            vim.bo[buf].modified = false
        end,
    })

    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function()
            vim.schedule(submit)
        end,
    })

    vim.keymap.set("n", "q", close, { buffer = buf, desc = "Cancel" })

    local data = { buf = buf, win = win, submit = submit, cancel = close }
    opts.on_create(data)
    vim.cmd.startinsert()
    return data
end

return M
