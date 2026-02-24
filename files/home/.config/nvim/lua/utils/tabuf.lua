local M = {}

local api = vim.api
local info = require "utils.info"

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

--- Switches to the next buffer in the current tab's scoped buffer list (wraps around).
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

--- Switches to the previous buffer in the current tab's scoped buffer list (wraps around).
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

--- Closes a buffer, prompting for force-close if it has unsaved changes.
--- @param bufnr? integer Buffer to close; defaults to the current buffer
function M.close(bufnr)
    bufnr = bufnr or cur_buf()
    if not api.nvim_buf_is_valid(bufnr) then return end
    local ok, _ = pcall(vim.api.nvim_buf_delete, bufnr, { force = false })
    if not ok then
        vim.ui.select({ "ok", "no" }, { prompt = "Force close" }, function(choice)
            if choice == "ok" then
                vim.api.nvim_buf_delete(bufnr, { force = true })
            end
        end)
    end
end

local function init_tab_bufs()
    if vim.t.bufs ~= nil then return end
    vim.t.bufs = vim.tbl_filter(function(buf)
        return info.buf.is_real_file(buf) and vim.fn.buflisted(buf) == 1
    end, api.nvim_list_bufs())
end

--- Sets up tab-scoped buffer tracking: each tab maintains its own buffer list
--- via `vim.t.bufs`, kept in sync by BufAdd/BufDelete/TabNew/TabEnter autocmds.
function M.setup()
    init_tab_bufs()

    local group = api.nvim_create_augroup("TabScopedBuffers", { clear = true })

    api.nvim_create_autocmd({ "BufAdd", "BufEnter", "TabNew" }, {
        group = group,
        callback = function(args)
            local buf = args.buf
            if not api.nvim_buf_is_valid(buf) then return end
            if not info.buf.is_real_file(buf) then return end
            if vim.fn.buflisted(buf) ~= 1 then return end

            local bufs = vim.t.bufs
            if bufs == nil then
                bufs = (cur_buf() == buf) and {} or { buf }
            elseif not vim.tbl_contains(bufs, buf) then
                table.insert(bufs, buf)
            end

            if args.event == "BufAdd" and #bufs > 1 then
                local first = bufs[1]
                if api.nvim_buf_is_valid(first)
                    and #api.nvim_buf_get_name(first) == 0
                    and not vim.bo[first].modified
                then
                    table.remove(bufs, 1)
                end
            end

            vim.t.bufs = bufs
        end,
    })

    api.nvim_create_autocmd("BufDelete", {
        group = group,
        callback = function(args)
            for _, tab in ipairs(api.nvim_list_tabpages()) do
                local bufs = vim.t[tab].bufs
                if bufs then
                    for i, bufnr in ipairs(bufs) do
                        if bufnr == args.buf then
                            table.remove(bufs, i)
                            vim.t[tab].bufs = bufs
                            break
                        end
                    end
                end
            end
        end,
    })

    api.nvim_create_autocmd("TabEnter", {
        group = group,
        callback = init_tab_bufs,
    })
end

return M
