local M = {}

local group = vim.api.nvim_create_augroup("remember_view", { clear = true })


function M.setup(viewoptions)
    if viewoptions then
        vim.opt.viewoptions = viewoptions
    end

    vim.api.nvim_create_autocmd("BufWinLeave", {
        group = group,
        callback = function()
            if vim.fn.expand("%:p") ~= "" then
                if vim.b.view_loaded then
                    vim.cmd [[mkview]]
                    vim.b.view_loaded = false
                end
            end
        end,
    })

    vim.api.nvim_create_autocmd("BufWinEnter", {
        group = group,
        callback = function(args)
            if vim.fn.expand("%:p") ~= "" then
                vim.schedule(function()
                    if not vim.api.nvim_buf_is_valid(args.buf) or
                        vim.api.nvim_get_current_buf() ~= args.buf then
                        return
                    end
                    vim.cmd [[silent! loadview]]
                    vim.b.view_loaded = true
                end)
            end
        end
    })
end

return M
