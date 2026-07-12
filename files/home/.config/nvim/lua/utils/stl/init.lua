local M = {}

M.global_name = "Statusline"
M.group = vim.api.nvim_create_augroup("StatusLine", { clear = true })
M.callbacks = {}

function M.git(opts)
    local default_git_props = {
        add    = { icon = "+", hi = "StlGitAdd" },
        remove = { icon = "-", hi = "StlGitRemove" },
        change = { icon = "~", hi = "StlGitChange" },
        branch = { hi = "StlGitBranch" },
    }
    local git_props = opts and vim.tbl_deep_extend("force", default_git_props, opts) or default_git_props

    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local status = require("utils.info").buf.git(bufnr)

    if not status then return end

    local components = {}
    table.insert(components, { hl = git_props.branch.hi, content = status.head or "" })

    if status.added and status.added > 0 then
        table.insert(components, { hl = git_props.add.hi, content = git_props.add.icon .. status.added })
    end
    if status.removed and status.removed > 0 then
        table.insert(components, { hl = git_props.remove.hi, content = git_props.remove.icon .. status.removed })
    end
    if status.changed and status.changed > 0 then
        table.insert(components, { hl = git_props.change.hi, content = git_props.change.icon .. status.changed })
    end

    return components
end

do
    local lsp_show = false
    function M.lsp(opts)
        opts = opts or {}
        lsp_show = opts.show or lsp_show

        local clients = {}
        local others = {}

        for _, client in pairs(vim.lsp.get_clients { bufnr = 0 }) do
            if client.name == "null-ls" then
                others["null-ls"] = require("utils.lsp").get_null_ls_sources()
            else
                table.insert(clients, client.name)
            end
        end

        if others["null-ls"] and #others["null-ls"] > 0 then
            table.insert(clients, "null-ls:[" .. table.concat(others["null-ls"], ", ") .. "]")
        end

        if #clients == 0 then return end

        return {
            content = lsp_show and table.concat(clients, ", ") or "LSP(" .. #clients .. ")",
            click = {
                name = "stl_toggle_lsp",
                callback = function()
                    lsp_show = not lsp_show
                    vim.cmd.redrawstatus()
                end,
            },
        }
    end
end

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
    local hl = opts.hl(mode)
    local label = opts.label(mode)

    opts.align = opts.align or "left"
    if opts.align == "center" then
        local LABEL_WIDTH = opts.width or 10

        local space_width = LABEL_WIDTH - #label
        local left_space_width = math.floor(space_width / 2)
        local right_space_width = space_width - left_space_width
        label = string.rep(" ", left_space_width) .. label .. string.rep(" ", right_space_width)
    elseif opts.align == "right" then
        local LABEL_WIDTH = opts.width or 10

        local space_width = LABEL_WIDTH - #label
        label = string.rep(" ", space_width) .. label
    elseif opts.align == "left" then
        local LABEL_WIDTH = opts.width or 10

        local space_width = LABEL_WIDTH - #label
        label = label .. string.rep(" ", space_width)
    end

    return {
        hl = hl,
        content = label,
        mode = mode,
    }
end

function M.bufnr()
    return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

function M.encoding()
    return require("utils.info").buf.encoding(M.bufnr())
end

function M.fileformat(opts)
    local default_formats = {
        ["unix"] = { icon = " ", label = "LF" },
        ["dos"]  = { icon = " ", label = "CRLF" },
        ["mac"]  = { icon = " ", label = "CR" },
    }
    local formats = opts and vim.tbl_deep_extend("force", default_formats, opts) or default_formats

    local fmt = require("utils.info").buf.fileformat(M.bufnr())
    if not fmt or fmt == "" then
        return nil
    end

    return formats[fmt] or { icon = "", label = fmt }
end

function M.macro_recording(opts)
    local default_props = {
        prefix = "@",
        hi = "StlMacro",
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local macro = vim.fn.reg_recording()
    if macro == "" then
        return nil
    end

    return {
        hl = props.hi,
        content = props.prefix .. macro,
    }
end

function M.search_count()
    local search = require("utils.info").buf.search_count(M.bufnr())
    if not search then return nil end

    return search.current .. "/" .. search.total
end

function M.file()
    local name = require("utils.info").buf.name(M.bufnr())
    if not name or name == "" then return nil end

    return name
end

function M.flags(opts)
    local default_props = {
        hi = "StlFileFlag",
        preview = "p",
        readonly = "r",
        modified = "+",
        unmodifiable = "-",
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local bufnr = M.bufnr()
    local info = require("utils.info").buf

    local flags = ""

    if vim.o.previewwindow then
        flags = flags .. props.preview
    end

    if info.is_readonly(bufnr) then
        flags = flags .. props.readonly
    elseif info.is_modifiable(bufnr) then
        if info.modified(bufnr) then
            flags = flags .. props.modified
        end
    else
        flags = flags .. props.unmodifiable
    end

    if flags == "" then
        return nil
    end

    return {
        hl = props.hi,
        content = flags,
    }
end

function M.filetype(opts)
    local default_props = {
        aliases = {
            ["javascript"] = "js",
            ["typescript"] = "ts",
            ["python"]     = "py",
        },
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local ft = require("utils.info").buf.filetype(M.bufnr())
    if not ft or ft == "" then
        return nil
    end

    local devicons = require("utils.plugin").get("nvim-web-devicons")
    if devicons then
        local icon, icon_color = devicons.get_icon_color_by_filetype(ft)
        if icon then
            local icon_hl = "StlIcon@" .. ft
            vim.api.nvim_set_hl(0, icon_hl, { fg = icon_color, bg = "none" })
            return {
                hl = icon_hl,
                content = icon .. " ",
            }
        end
    end

    local fallback = props.aliases[ft]
    if not fallback or fallback == "" then
        return nil
    end

    return fallback
end

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
