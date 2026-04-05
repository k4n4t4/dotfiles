local M = {}

local hi = require("utils.highlight")
local info = require("utils.info")
local mapping = require("utils.mapping")

M.mode = require("utils.statusline.components.mode")
M.filetype = require("utils.statusline.components.filetype")
M.git = require("utils.statusline.components.git")
M.diagnostic = require("utils.statusline.components.diagnostic")
M.flag = require("utils.statusline.components.flag")
M.lsp = require("utils.statusline.components.lsp")

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
