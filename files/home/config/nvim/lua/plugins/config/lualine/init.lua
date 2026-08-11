local M = {}

local function is_visual_mode()
    local mode = vim.fn.mode()
    return mode == 'v' or mode == 'V' or mode == '\22'
end

local function macro_status()
    local reg = vim.fn.reg_recording()
    if reg ~= "" then
        return "rec @" .. reg
    end
    return ""
end

local function lsp_counts()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        return ""
    end
    return " " .. #clients
end

local function visual_info()
    local mode = vim.fn.mode()

    local l1, l2 = vim.fn.line('v'), vim.fn.line('.')
    local lines = math.abs(l2 - l1) + 1

    if mode == 'V' then
        return string.format('%d lines', lines)
    elseif mode == '\22' then
        local c1, c2 = vim.fn.virtcol('v'), vim.fn.virtcol('.')
        local cols = math.abs(c2 - c1) + 1
        return string.format('%dx%d', lines, cols)
    elseif mode == 'v' then
        local wc = vim.fn.wordcount()
        local chars = wc.visual_chars or 0
        if lines > 1 then
            return string.format('%d lines %d chars', lines, chars)
        else
            return string.format('%d chars', chars)
        end
    else
        return ''
    end
end


function M.config()
    vim.opt.cmdheight = 0
    vim.opt.laststatus = 3
    vim.opt.showcmd = true
    vim.opt.showcmdloc = "last"

    vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
        group = vim.api.nvim_create_augroup("LualineMacroRefresh", { clear = true }),
        callback = function() require("lualine").refresh() end,
    })

    require("lualine").setup {
        options = {
            icons_enabled = true,
            theme = "auto",
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            globalstatus = true,
            disabled_filetypes = { "dashboard", "snacks_dashboard" },
        },
        sections = {
            lualine_a = {
                "mode",
                macro_status,
            },
            lualine_b = {
                "branch",
                {
                    "diff",
                    symbols = {
                        added    = " ",
                        modified = " ",
                        removed  = " ",
                    },
                },
                {
                    "diagnostics",
                    symbols = {
                        error = '󰅚 ',
                        warn =  '󰀪 ',
                        info =  '󰋽 ',
                        hint =  '󰌶 ',
                    },
                },
            },
            lualine_c = {
                {
                    "filetype",
                    fmt = function(name)
                        if name == "" then
                            return " "
                        end
                        return name
                    end,
                    icon_only = true,
                    separator = "",
                    padding = { left = 1, right = 0 },
                },
                {
                    "filename",
                    path = 0,
                    file_status = true,
                    newfile_status = true,
                    shorting_target = 40,
                    padding = { left = 0 },
                    symbols = {
                        modified = " ",
                        readonly = " ",
                        unnamed  = "",
                        newfile  = " ",
                    },
                },
            },
            lualine_x = {
                {
                    function()
                        ---@diagnostic disable-next-line: undefined-field
                        return require("noice").api.status.command.get()
                    end,
                    cond = function()
                        return not is_visual_mode() and
                        package.loaded["noice"] and
                        ---@diagnostic disable-next-line: undefined-field
                        require("noice").api.status.command.has()
                    end,
                },
                {
                    visual_info,
                    cond = is_visual_mode,
                },
                {
                    "searchcount",
                },
            },
            lualine_y = {
                lsp_counts,
                {
                    "encoding",
                    separator = "",
                    padding = { left = 1, right = 0 },
                },
                {
                    "fileformat",
                    padding = { left = 1, right = 1 },
                },
            },
            lualine_z = {
                "progress",
                "location",
            },
        },
        extensions = {},
    }
end

return M
