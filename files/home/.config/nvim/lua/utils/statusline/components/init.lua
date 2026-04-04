local M = {}

local hi = require("utils.highlight")
local info = require("utils.info")
local mapping = require("utils.mapping")

M.mode = require("utils.statusline.components.mode")
M.filetype = require("utils.statusline.components.filetype")
M.git = require("utils.statusline.components.git")
M.diagnostic = require("utils.statusline.components.diagnostic")
M.flag = require("utils.statusline.components.flag")

local function stl_buf()
    return vim.api.nvim_win_get_buf(vim.g.statusline_winid)
end

function M.encoding()
    return info.buf.encoding(stl_buf())
end

function M.fileformat()
    local fmt = info.buf.fileformat(stl_buf()) or ""
    return mapping.fileformat.get(fmt).label
end

local utils_lsp = require "utils.lsp"
M.lsp_show = false
function StlToggleLspShow()
    M.lsp_show = not M.lsp_show
    vim.cmd.redrawstatus()
end
function M.lsp()
    local s = ""

    local clients, others = utils_lsp.get(0)
    if others["null-ls"] and #others["null-ls"] > 0 then
        table.insert(clients, "null-ls:[" .. table.concat(others["null-ls"], ", ") .. "]")
    end

    if #clients == 0 then
        return ""
    end

    if not M.lsp_show then
        s = "LSP(" .. #clients .. ")"
    else
        s = table.concat(clients, ", ")
    end

    return "%@v:lua.StlToggleLspShow@" .. s .. "%X"
end

function M.macro_recording()
    local macro = info.state.macro()
    if macro ~= "" then
        return hi.use("StlMacro") .. "@" .. macro .. "%*"
    end
    return ""
end

function M.search_count()
    local search = info.buf.search_count(0)
    if search then
        return "[" .. search.current .. "/" .. search.total .. "] "
    end
    return ""
end

function M.file()
    return info.buf.name(stl_buf()) or ""
end

return M
