local M = {}

M.global_name = "Statusline"
M.group = vim.api.nvim_create_augroup("StatusLine", { clear = true })
M.callbacks = {}

M.diagnostic      = require "utils.stl.components.diagnostic"
M.git             = require "utils.stl.components.git"
M.lsp             = require "utils.stl.components.lsp"
M.mode            = require "utils.stl.components.mode"
M.encoding        = require "utils.stl.components.encoding"
M.fileformat      = require "utils.stl.components.fileformat"
M.macro_recording = require "utils.stl.components.macro_recording"
M.search_count    = require "utils.stl.components.search_count"
M.file            = require "utils.stl.components.file"
M.flags           = require "utils.stl.components.flags"
M.filetype        = require "utils.stl.components.filetype"


---@class StatuslineClick
---@field name string
---@field callback fun(minwid: number, clicks: number, button: string, modifiers: string)

---@class StatuslineNode
---@field hl? string highlight group name
---@field click? StatuslineClick
---@field content? string|(string|StatuslineNode)[] output string or child nodes

---@class StatuslineState
---@field hl? string current highlight group name
---@field click? string current click function name
---@field is_child? boolean internal flag to detect recursive calls

---@param tbls (string|StatuslineNode)[] list of strings or statusline nodes
---@param stat? StatuslineState status object to keep track of current highlight group
---@return string generated statusline format string
function M.make_str(tbls, stat)
    stat = stat or {}

    if not stat.is_child then M.callbacks = {} end

    stat.hl = stat.hl or ""
    stat.click = stat.click or ""

    local str = ""
    for _, tbl in ipairs(tbls) do
        if type(tbl) == "string" then
            str = str .. tbl
        elseif type(tbl) == "table" then
            local hl = tbl.hl or stat.hl
            local click_name = stat.click

            if tbl.click and tbl.click.name and tbl.click.callback then
                click_name = tbl.click.name
                M.callbacks[click_name] = tbl.click.callback
            end

            local node_content = tbl.content
            local content = ""
            if type(node_content) == "string" then
                content = node_content
            elseif type(node_content) == "table" then
                content = M.make_str(node_content, { hl = hl, click = click_name, is_child = true })
            end

            local click_str = ""
            local restore_click = ""
            if tbl.click and tbl.click.name then
                click_str = "%@v:lua." .. M.global_name .. ".callbacks." .. tbl.click.name .. "@"
                restore_click = (stat.click == "") and (
                    "%X"
                ) or (
                    "%@v:lua." .. M.global_name .. ".callbacks." .. stat.click .. "@"
                )
            end

            if tbl.hl then
                local restore_hl = (stat.hl == "") and (
                    "%*"
                ) or (
                    "%#" .. stat.hl .. "#"
                )
                str = str .. "%#" .. tbl.hl .. "#" .. click_str .. content .. restore_click .. restore_hl
            else
                str = str .. click_str .. content .. restore_click
            end
        end
    end
    return str
end

---@class StatuslineOpts
---@field global_name? string global variable name to store the statusline module
---@field statusline? fun():string function to generate the statusline string
---@field redraw? table
---@field redraw.event? string[]|string event name to trigger statusline redraw
---@field redraw.ignore_ft? string[] list of filetypes to ignore for redraw
---@field redraw.ignore_bt? string[] list of buftypes to ignore for redraw

---@param opts StatuslineOpts
function M.setup(opts)
    opts = opts or {}

    M.global_name = opts.global_name or M.global_name
    _G[M.global_name] = M

    opts.statusline = opts.statusline or function() return "" end
    M.statusline = opts.statusline

    opts.redraw = opts.redraw or {}
    opts.redraw.event = opts.redraw.event or "ModeChanged"
    opts.redraw.ignore_ft = opts.redraw.ignore_ft or {
        "TelescopePrompt",
        "NvimTree",
        "neo-tree",
        "fzf",
        "copilot-chat",
    }
    opts.redraw.ignore_bt = opts.redraw.ignore_bt or {
        "terminal",
        "nofile",
        "prompt",
    }

    vim.opt.statusline = "%!v:lua."..M.global_name..".statusline()"

    -- Redraw statusline when mode changed. (e.g. 'ix' mode)
    if opts.redraw.event ~= "" then
        if M.redrawid then vim.api.nvim_del_autocmd(M.redrawid) end
        M.redrawid = vim.api.nvim_create_autocmd(opts.redraw.event, {
            group = M.group,
            callback = function()
                if vim.tbl_contains(opts.redraw.ignore_bt, vim.bo.filetype) or
                    vim.tbl_contains(opts.redraw.ignore_ft, vim.bo.buftype) then
                    return
                end
                vim.cmd.redrawstatus()
            end,
        })
    end
end

return M
