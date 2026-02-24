local M = {}

M.group = vim.api.nvim_create_augroup("StatusLine", { clear = true })


function M.setup()
    require "core.ui.statusline.highlights"
    require "core.ui.statusline.format"

    vim.opt.showcmdloc = 'statusline'
    vim.opt.cmdheight = 0
    vim.opt.laststatus = 3
    vim.opt.statusline = "%!v:lua.StatusLine()"

    -- Redraw statusline when mode changed. (e.g. 'ix' mode)
    vim.api.nvim_create_autocmd("ModeChanged", {
        group = M.group,
        callback = function()
            local ignore_ft = {
                "TelescopePrompt",
                "NvimTree",
                "neo-tree",
                "fzf",
                "copilot-chat",
            }
            local ignore_bt = {
                "terminal",
                "nofile",
                "prompt",
            }

            if vim.tbl_contains(ignore_ft, vim.bo.filetype) or
                vim.tbl_contains(ignore_bt, vim.bo.buftype) then
                return
            end

            vim.cmd.redrawstatus()
        end,
    })
end

M.setup()

return M
