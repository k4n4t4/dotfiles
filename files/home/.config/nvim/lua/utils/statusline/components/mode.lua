return function(opts)
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
