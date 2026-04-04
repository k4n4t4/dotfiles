--- Get the maximum number of sign slots from the signcolumn option
--- @param winid integer
--- @return integer
local function get_max_slots(winid)
    local sc = vim.wo[winid].signcolumn
    if sc == "no" or sc == "number" then return 0 end
    local n = sc:match(":(%d+)$")
    return tonumber(n) or 1
end

--- Return signs for the specified line in descending priority order
--- @param bufnr integer
--- @param lnum integer 1-indexed
--- @return { text: string, hl: string, priority: integer }[]
local function get_signs(bufnr, lnum)
    local signs = {}
    local extmarks = vim.api.nvim_buf_get_extmarks(
        bufnr, -1,
        { lnum - 1, 0 },
        { lnum - 1, -1 },
        { details = true, type = "sign" }
    )
    for _, mark in ipairs(extmarks) do
        local d = mark[4]
        if d and d.sign_text then
            table.insert(signs, {
                text     = d.sign_text,
                hl       = d.sign_hl_group or "",
                priority = d.priority or 0,
            })
        end
    end
    table.sort(signs, function(a, b) return a.priority > b.priority end)
    return signs
end

--- @param winid integer
--- @return string
return function(winid)
    local slots = get_max_slots(winid)
    if slots == 0 then return "" end

    if vim.v.virtnum ~= 0 then
        return string.rep("  ", slots)
    end

    local bufnr = vim.api.nvim_win_get_buf(winid)
    local signs = get_signs(bufnr, vim.v.lnum)

    local result = ""
    for i = 1, slots do
        local s = signs[i]
        if s then
            local text = s.text
            if s.hl ~= "" then
                result = result .. "%#" .. s.hl .. "#" .. text .. "%*"
            else
                result = result .. text
            end
        else
            result = result .. "  "
        end
    end
    return result
end
