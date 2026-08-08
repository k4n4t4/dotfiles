local M = {}

local header_text = [[
     ██████ ▄▄▄▄▄ ▄▄ ▄▄ ▄▄▄▄▄▄    
       ██   ██▄▄  ▀█▄█▀   ██      
       ██   ██▄▄▄ ██ ██   ██      
██████ ▄▄▄▄  ▄▄ ▄▄▄▄▄▄  ▄▄▄  ▄▄▄▄ 
██▄▄   ██▀██ ██   ██   ██▀██ ██▄█▄
██▄▄▄▄ ████▀ ██   ██   ▀███▀ ██ ██
]]

M.preset =  {
    header = { header_text, hl = "Comment", align = "center" },
}

return M
