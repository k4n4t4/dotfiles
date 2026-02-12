-- require "core.ui.tabline.highlights"
-- require "core.ui.tabline.format"
--
-- vim.opt.showtabline = 2
-- vim.opt.tabline = "%!v:lua.TabLine()"

local info = require "utils.info"

function HandleTabClick(tabnr, _, button, _)
    if button == "l" then
        vim.cmd(tabnr .. "tabnext")
    elseif button == "m" then
        vim.cmd(tabnr .. "tabclose")
    end
end

function HandleBufClick(bufnr, _, button, _)
    if button == "l" then
        vim.api.nvim_set_current_buf(bufnr)
    elseif button == "m" then
        vim.api.nvim_buf_delete(bufnr, { force = false })
    end
end

local function tab_format(opts)
    local s = ""
    local tabpages = vim.api.nvim_list_tabpages()
    local tabpage = tabpages[opts.tabnr]
    if not tabpage then return s end

    local is_active = opts.is_current_tab
    local bufs = info.tab.buflist(tabpage)
    local cur_buf = vim.api.nvim_get_current_buf()
    local tab_hi = is_active and "%#TabLineSel#" or "%#TabLine#"

    s = s .. tab_hi .. "%" .. opts.tabnr .. "@v:lua.HandleTabClick@" .. " <tab" .. opts.tabnr .. " "

    for _, bufnr in ipairs(bufs) do
        if info.buf.is_real_file(bufnr) then
            local is_buf_active = (bufnr == cur_buf)
            local buf_hi = is_buf_active and "%#BufferActive#" or tab_hi
            local name = info.buf.name(bufnr)
            local mod = info.buf.modified(bufnr) and " +" or ""
            local ro = info.buf.is_readonly(bufnr) and " R" or ""
            s = s .. buf_hi .. "%" .. bufnr .. "@v:lua.HandleBufClick@[" .. name .. mod .. ro .. "]%X"
        end
    end

    s = s .. tab_hi .. "%X> "
    return s
end

local function tabline_format(opts)
    local s = ""
    local all_tab_bufs = {}

    for tabnr = 1, opts.tab_count do
        s = s .. tab_format {
            tabnr = tabnr;
            is_current_tab = tabnr == opts.current_tabnr;
        }
        local tabpage = vim.api.nvim_list_tabpages()[tabnr]
        if tabpage then
            for _, b in ipairs(info.tab.buflist(tabpage)) do
                all_tab_bufs[b] = true
            end
        end
    end

    local cur_buf = vim.api.nvim_get_current_buf()
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if info.buf.is_real_file(bufnr) and not all_tab_bufs[bufnr] then
            local is_buf_active = (bufnr == cur_buf)
            local buf_hi = is_buf_active and "%#BufferActive#" or "%#TabLine#"
            local name = info.buf.name(bufnr)
            local mod = info.buf.modified(bufnr) and " +" or ""
            local ro = info.buf.is_readonly(bufnr) and " R" or ""
            s = s .. buf_hi .. "%" .. bufnr .. "@v:lua.HandleBufClick@[" .. name .. mod .. ro .. "]%X "
        end
    end

    s = s .. "%#TabLineFill#%="
    return s
end

function TabLine()
    local opts = {
        tab_count = vim.fn.tabpagenr('$');
        current_tabnr = vim.fn.tabpagenr();
    }
    return tabline_format(opts)
end


vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.TabLine()"
