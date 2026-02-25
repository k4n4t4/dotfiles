local M = {}

--- Creates a mapping object from a key -> value table.
--- Returns an object with `get`, `set`, and `extend` methods.
--- If the key is not found, `fallback(key)` is called (default: returns the key as-is).
--- @param tbl table<string, any>
--- @param fallback? fun(key: string): any
--- @return { get: fun(key: string): any, set: fun(key: string, value: any), extend: fun(entries: table<string, any>) }
function M.new(tbl, fallback)
    fallback = fallback or function(k) return k end
    return {
        get = function(key)
            local v = tbl[key]
            return v ~= nil and v or fallback(key)
        end,
        --- Updates a single entry.
        set = function(key, value)
            tbl[key] = value
        end,
        --- Merges multiple entries at once.
        --- @param entries table<string, any>
        extend = function(entries)
            for k, v in pairs(entries) do
                tbl[k] = v
            end
        end,
    }
end

--- Vim mode mapping: raw mode string -> { name, label }
--- name  = abbreviated display name (e.g. "N", "I", "VB")
--- label = full display name       (e.g. "NORMAL", "INSERT", "V-BLOCK")
M.mode = M.new({
    ["n"]   = { name = "N",   label = "NORMAL" },
    ["no"]  = { name = "NO",  label = "O-PENDING" },
    ["nov"] = { name = "NOC", label = "O-PENDING-C" },
    ["noV"] = { name = "NOL", label = "O-PENDING-L" },
    ["no"]  = { name = "NOB", label = "O-PENDING-B" },
    ["niI"] = { name = "NI",  label = "N-INSERT" },
    ["niR"] = { name = "NR",  label = "N-REPLACE" },
    ["niV"] = { name = "NV",  label = "N-VISUAL" },
    ["nt"]  = { name = "NT",  label = "N-TERMINAL" },
    ["ntT"] = { name = "NTT", label = "N-TERM-T" },
    ["v"]   = { name = "V",   label = "VISUAL" },
    ["vs"]  = { name = "VS",  label = "VISUAL-S" },
    ["V"]   = { name = "VL",  label = "V-LINE" },
    ["Vs"]  = { name = "VLS", label = "V-LINE-S" },
    [""]    = { name = "VB",  label = "V-BLOCK" },
    ["s"]   = { name = "VBS", label = "V-BLOCK-S" },
    ["s"]   = { name = "S",   label = "SELECT" },
    ["S"]   = { name = "SL",  label = "S-LINE" },
    [""]   = { name = "SB",  label = "S-BLOCK" },
    ["i"]   = { name = "I",   label = "INSERT" },
    ["ic"]  = { name = "IC",  label = "INSERT-C" },
    ["ix"]  = { name = "IX",  label = "INSERT-X" },
    ["R"]   = { name = "R",   label = "REPLACE" },
    ["Rc"]  = { name = "RC",  label = "REPLACE-C" },
    ["Rx"]  = { name = "RX",  label = "REPLACE-X" },
    ["Rv"]  = { name = "RV",  label = "V-REPLACE" },
    ["Rvc"] = { name = "RVC", label = "V-REPLACE-C" },
    ["Rvx"] = { name = "RVX", label = "V-REPLACE-X" },
    ["c"]   = { name = "C",   label = "COMMAND" },
    ["cr"]  = { name = "CR",  label = "COMMAND-R" },
    ["cv"]  = { name = "EX",  label = "EX" },
    ["cvr"] = { name = "EXR", label = "EX-R" },
    ["r"]   = { name = "P",   label = "ENTER" },
    ["rm"]  = { name = "M",   label = "MORE" },
    ["r?"]  = { name = "CF",  label = "CONFIRM" },
    ["!"]   = { name = "SH",  label = "SHELL" },
    ["t"]   = { name = "T",   label = "TERMINAL" },
}, function(k) return { name = k:upper(), label = k:upper() } end)

--- File format mapping: vim fileformat string -> { label, symbol }
--- label  = short display label (e.g. "LF", "CRLF", "CR")
--- symbol = Unicode symbol       (e.g. "↲", "↵", "←")
M.fileformat = M.new({
    ["unix"] = { label = "LF",   symbol = "↲" },
    ["dos"]  = { label = "CRLF", symbol = "↵" },
    ["mac"]  = { label = "CR",   symbol = "←" },
}, function(k) return { label = k, symbol = k } end)

--- Diagnostic severity mapping: severity name string -> { icon, label }
--- icon  = short single-char indicator
--- label = human-readable severity name
M.severity = M.new({
    ["ERROR"] = { icon = "!", label = "Error" },
    ["WARN"]  = { icon = "*", label = "Warn" },
    ["INFO"]  = { icon = "i", label = "Info" },
    ["HINT"]  = { icon = "?", label = "Hint" },
}, function(k) return { icon = "·", label = k } end)

--- Filetype alias mapping: long filetype name -> short display name
M.filetype_alias = M.new({
    ["javascript"] = "js",
    ["typescript"] = "ts",
    ["python"]     = "py",
})

return M
