local M = {}

M.mode = require("core.ui.statusline.components.mode")
M.filetype = require("core.ui.statusline.components.filetype")
M.git = require("core.ui.statusline.components.git")
M.diagnostic = require("core.ui.statusline.components.diagnostic")
M.flag = require("core.ui.statusline.components.flag")

function M.encoding()
    return vim.o.fenc or vim.o.enc
end

function M.fileformat()
    return vim.o.ff
end

local utils_lsp = require "utils.lsp"
function M.lsp()
    local clients, others = utils_lsp.get(0)
    if others["null-ls"] and #others["null-ls"] > 0 then
        table.insert(clients, "null-ls:[" .. table.concat(others["null-ls"], ", ") .. "]")
    end
    return table.concat(clients, ", ")
end

function M.macro_recording()
    local format = {}
    local macro = vim.fn.reg_recording()
    if macro ~= "" then
        table.insert(format, "%#StlMacro#")
        table.insert(format, "@" .. macro)
        table.insert(format, "%*")
    end
    return table.concat(format, "")
end

function M.search_count()
    local format = {}

    local search = vim.fn.searchcount()

    if search.total ~= nil and vim.v.hlsearch == 1 then
        table.insert(format, "[" .. search.current .. "/" .. search.total .. "] ")
    end

    return table.concat(format, "")
end

function M.file()
    local full_path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
    return vim.fn.fnamemodify(full_path, ":t")
end

return M
