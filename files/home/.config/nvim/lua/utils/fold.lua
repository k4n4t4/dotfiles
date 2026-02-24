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

--- Returns fold information for a given line in a window via FFI.
--- @param wp ffi.cdata* Window pointer (obtain via `M.find_window`)
--- @param lnum number 1-based line number
--- @return { lnum: number, level: number, low_level: number, lines: number }
M.fold_info = function(wp, lnum)
    local foldinfo = C.fold_info(wp, lnum)
    return {
        lnum = foldinfo.fi_lnum,
        level = foldinfo.fi_level,
        low_level = foldinfo.fi_low_level,
        lines = foldinfo.fi_lines,
    }
end

--- Returns true if the given line in the window is folded (via FFI).
--- @type fun(wp: ffi.cdata*, lnum: number): boolean
M.lineFolded = C.lineFolded

--- Looks up the internal Neovim window struct for a window handle via FFI.
---@param winnr number Window handle (nvim window id)
---@return ffi.cdata*
M.find_window = function(winnr)
    return C.find_window_by_handle(winnr, error)
end


--- Returns full fold information for a line, including whether it is currently folded.
--- Optionally accepts an already-resolved window pointer to avoid redundant FFI calls.
---@param winnr number Window handle
---@param lnum number 1-based line number
---@param wp? ffi.cdata* Pre-resolved window pointer (optional; fetched if omitted)
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
