local M = {}

local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.7)
    local height = opts.height or math.floor(vim.o.lines * 0.7)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local buf = nil
    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true)
    end

    local win_config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "single",
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)

    vim.wo[win].winblend = opts.winblend or 0

    return { buf = buf, win = win }
end

M.group = vim.api.nvim_create_augroup("Terminal", { clear = true })

M.state = {
    floating = {
        buf = -1,
        win = -1,
    }
}

function M.toggle_terminal()
    if not vim.api.nvim_win_is_valid(M.state.floating.win) then
        M.state.floating = create_floating_window {
            buf = M.state.floating.buf,
            winblend = 10,
        }
        if vim.bo[M.state.floating.buf].buftype ~= "terminal" then
            vim.cmd.term()
        end
    else
        vim.api.nvim_win_hide(M.state.floating.win)
    end
end

function M.setup()
    local keymap = vim.keymap
    local set = keymap.set

    -- terminal
    set('t', '<esc>', "<C-\\><C-n>")
    set('n', '<leader>kk', "<cmd>belowright 10split<cr><cmd>terminal<cr>", { desc = "Terminal" })
    set("n", "<leader>kf", M.toggle_terminal, { desc = "Terminal (floating)" })
    set('n', '<leader>K', "<cmd>terminal<cr>", { desc = "Terminal (full)" })

    local autocmd = vim.api.nvim_create_autocmd

    autocmd("TermOpen", {
        group = M.group,
        callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.foldcolumn = '0'
            vim.opt_local.signcolumn = "no"
            vim.cmd [[startinsert]]
        end,
    })

    autocmd("TermClose", {
        group = M.group,
        pattern = 'term://*fish',
        callback = function()
            vim.api.nvim_input("<CR>")
        end,
    })

    autocmd("BufEnter", {
        group = M.group,
        pattern = 'term://*',
        callback = function()
            vim.cmd [[startinsert]]
        end,
    })
end

M.setup()

return M
