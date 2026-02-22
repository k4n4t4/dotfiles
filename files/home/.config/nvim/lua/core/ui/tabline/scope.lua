local M = {}

local api = vim.api

local function cur_buf()
    return api.nvim_get_current_buf()
end

local function set_buf(bufnr)
    if bufnr and api.nvim_buf_is_valid(bufnr) then
        api.nvim_set_current_buf(bufnr)
    end
end

local function buf_index(bufnr)
    local bufs = vim.t.bufs or {}
    for i, v in ipairs(bufs) do
        if v == bufnr then return i end
    end
end

function M.next()
    local bufs = vim.t.bufs or {}
    if #bufs == 0 then return end
    local idx = buf_index(cur_buf())
    if not idx then
        set_buf(bufs[1])
        return
    end
    set_buf(idx == #bufs and bufs[1] or bufs[idx + 1])
end

function M.prev()
    local bufs = vim.t.bufs or {}
    if #bufs == 0 then return end
    local idx = buf_index(cur_buf())
    if not idx then
        set_buf(bufs[1])
        return
    end
    set_buf(idx == 1 and bufs[#bufs] or bufs[idx - 1])
end

--- @param bufnr? integer
function M.close(bufnr)
    bufnr = bufnr or cur_buf()
    if not api.nvim_buf_is_valid(bufnr) then return end
    vim.cmd(("bdelete %d"):format(bufnr))
end

return M
