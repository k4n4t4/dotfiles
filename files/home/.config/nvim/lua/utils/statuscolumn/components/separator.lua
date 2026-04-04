local hi = require("utils.highlight")

return function()
    if vim.v.lnum == vim.fn.line(".") then
        return hi.use("CursorLineNr") .. "▌%*"
    else
        return hi.use("LineNr") .. "│%*"
    end
end
