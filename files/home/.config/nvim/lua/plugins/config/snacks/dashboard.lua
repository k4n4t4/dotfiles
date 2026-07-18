local M = {}

local header = {
    { "     ██████ ▄▄▄▄▄ ▄▄ ▄▄ ▄▄▄▄▄▄    \n", hl = "Number",  align = "center" },
    { "       ██   ██▄▄  ▀█▄█▀   ██      \n", hl = "String",  align = "center" },
    { "       ██   ██▄▄▄ ██ ██   ██      \n", hl = "Boolean", align = "center" },
    { "██████ ▄▄▄▄  ▄▄ ▄▄▄▄▄▄  ▄▄▄  ▄▄▄▄ \n", hl = "Number",  align = "center" },
    { "██▄▄   ██▀██ ██   ██   ██▀██ ██▄█▄\n", hl = "String",  align = "center" },
    { "██▄▄▄▄ ████▀ ██   ██   ▀███▀ ██ ██\n", hl = "Boolean", align = "center" },
}

M.preset =  {
    header = header,
}

function M.hide_line_setup()
    ---@diagnostic disable-next-line: undefined-field
    local saved_laststatus = vim.opt.laststatus:get()
    ---@diagnostic disable-next-line: undefined-field
    local saved_tabline = vim.opt.showtabline:get()
    local hidden = false

    local function hide()
        if hidden then return end
        hidden = true
        ---@diagnostic disable-next-line: undefined-field
        saved_laststatus = vim.opt.laststatus:get()
        ---@diagnostic disable-next-line: undefined-field
        saved_tabline = vim.opt.showtabline:get()
        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
    end

    local function restore()
        if not hidden then return end
        hidden = false
        vim.opt.laststatus = saved_laststatus
        vim.opt.showtabline = saved_tabline
    end

    vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = hide,
    })
    vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardClosed",
        callback = restore,
    })

    local count = 0
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(args)
            if args.data == "lualine.nvim" then
                if vim.bo.filetype == "snacks_dashboard" then
                    vim.opt.laststatus = 0
                end
                count = count + 1
            end
            if args.data == "bufferline.nvim" then
                if vim.bo.filetype == "snacks_dashboard" then
                    vim.opt.showtabline = 0
                end
                count = count + 1
            end
            return count >= 2
        end,
    })
end

return M
