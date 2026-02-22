local M = {}

local api = vim.api
local info = require "utils.info"

local function cur_buf()
    return api.nvim_get_current_buf()
end

local function init_tab_bufs()
    if vim.t.bufs ~= nil then return end
    vim.t.bufs = vim.tbl_filter(function(buf)
        return info.buf.is_real_file(buf) and vim.fn.buflisted(buf) == 1
    end, api.nvim_list_bufs())
end

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

M.setup()

return M
