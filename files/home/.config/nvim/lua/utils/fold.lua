local ffi = require "ffi"

local M = {}


ffi.cdef [[
    typedef struct {} Error;
    typedef struct {} win_T;

    typedef struct {
        int fi_lnum;
        int fi_level;
        int fi_low_level;
        int fi_lines;
    } foldinfo_T;

    win_T *find_window_by_handle(int Window, Error *err);
    foldinfo_T fold_info(win_T* wp, int lnum);
    bool lineFolded(win_T* wp, int lnum);
]]

local C = ffi.C
local error = ffi.new "Error"

M.fold_info = function(wp, lnum)
    local foldinfo = C.fold_info(wp, lnum)
    return {
        lnum = foldinfo.fi_lnum,
        level = foldinfo.fi_level,
        low_level = foldinfo.fi_low_level,
        lines = foldinfo.fi_lines,
    }
end

M.lineFolded = C.lineFolded

---@param winnr number
---@return ffi.cdata*
M.find_window = function(winnr)
    return C.find_window_by_handle(winnr, error)
end


---@param winnr number
---@param lnum number
---@param wp? ffi.cdata*
---@return {
---    lnum: number;
---    level: number;
---    low_level: number;
---    lines: number;
---    folded: boolean;
---    wp: ffi.cdata*;
---}
function M.get(winnr, lnum, wp)
    wp = wp or M.find_window(winnr)
    local fi = M.fold_info(wp, lnum)
    return {
        lnum = fi.lnum,
        level = fi.level,
        low_level = fi.low_level,
        lines = fi.lines,
        folded = M.lineFolded(wp, lnum),
        wp = wp,
    }
end

return M
