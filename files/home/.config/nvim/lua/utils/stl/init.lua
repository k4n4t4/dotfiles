local M = {}

M.group = vim.api.nvim_create_augroup("StatusLine", { clear = true })


function M.mode(opts)
    opts = opts or {}
    opts.hl = opts.hl or function(mode)
        local mode_hi = {
            ["n"] = "StlModeNormal",
            ["i"] = "StlModeInsert",
            ["R"] = "StlModeReplace",
            ["v"] = "StlModeVisual",
            ["V"] = "StlModeVisual",
            [""] = "StlModeVisual",
            ["t"] = "StlModeTerminal",
            ["!"] = "StlModeTerminal",
            ["r?"] = "StlModeConfirm",
        }
        return mode_hi[mode.mode] or
            mode_hi[mode.mode:sub(1, 1)] or
            "StlModeOther"
    end
    opts.label = opts.label or function(mode)
        local mode_label = {
            ["n"]   =  "NORMAL",
            ["no"]  =  "O-PENDING",
            ["nov"] =  "O-PENDING-C",
            ["noV"] =  "O-PENDING-L",
            ["no"] =  "O-PENDING-B",
            ["niI"] =  "N-INSERT",
            ["niR"] =  "N-REPLACE",
            ["niV"] =  "N-VISUAL",
            ["nt"]  =  "N-TERMINAL",
            ["ntT"] =  "N-TERM-T",
            ["v"]   =  "VISUAL",
            ["vs"]  =  "VISUAL-S",
            ["V"]   =  "V-LINE",
            ["Vs"]  =  "V-LINE-S",
            [""]   =  "V-BLOCK",
            ["s"]  =  "V-BLOCK-S",
            ["s"]   =  "SELECT",
            ["S"]   =  "S-LINE",
            [""]   =  "S-BLOCK",
            ["i"]   =  "INSERT",
            ["ic"]  =  "INSERT-C",
            ["ix"]  =  "INSERT-X",
            ["R"]   =  "REPLACE",
            ["Rc"]  =  "REPLACE-C",
            ["Rx"]  =  "REPLACE-X",
            ["Rv"]  =  "V-REPLACE",
            ["Rvc"] =  "V-REPLACE-C",
            ["Rvx"] =  "V-REPLACE-X",
            ["c"]   =  "COMMAND",
            ["cr"]  =  "COMMAND-R",
            ["cv"]  =  "EX",
            ["cvr"] =  "EX-R",
            ["r"]   =  "ENTER",
            ["rm"]  =  "MORE",
            ["r?"]  =  "CONFIRM",
            ["!"]   =  "SHELL",
            ["t"]   =  "TERMINAL",
        }
        return mode_label[mode.mode] or mode.mode:upper()
    end

    local mode  = vim.api.nvim_get_mode()

    return {
        hl = opts.hl(mode),
        label = opts.label(mode),
        mode = mode,
    }
end


---@class StatuslineNode
---@field hl? string highlight group name
---@field content? string|(string|StatuslineNode)[] output string or child nodes

---@class StatuslineState
---@field hl? string current highlight group name

---@param tbls (string|StatuslineNode)[] list of strings or statusline nodes
---@param stat? StatuslineState status object to keep track of current highlight group
---@return string generated statusline format string
function M.make_str(tbls, stat)
    stat = stat or {}
    stat.hl = stat.hl or ""

    local str = ""
    for _, tbl in ipairs(tbls) do
        if type(tbl) == "string" then
            str = str .. tbl
        elseif type(tbl) == "table" then
            local hl = tbl.hl or stat.hl
            local node_content = tbl.content
            local content = ""
            if type(node_content) == "string" then
                content = node_content
            elseif type(node_content) == "table" then
                content = M.make_str(node_content, { hl = hl })
            end
            if tbl.hl then
                local restore_hl = (stat.hl == "") and (
                    "%*"
                ) or (
                    "%#" .. stat.hl .. "#"
                )
                str = str .. "%#" .. tbl.hl .. "#" .. content .. restore_hl
            else
                str = str .. content
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

    opts.global_name = opts.global_name or "Statusline"
    _G[opts.global_name] = M

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

    vim.opt.statusline = "%!v:lua."..opts.global_name..".statusline()"

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
