require "core.ui.tabline.highlights"
require "core.ui.tabline.format"

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.TabLine()"

-- local info = require "utils.info"
--
--
-- local function tab_format(opts)
--     local s = ""
--     return s
-- end
--
-- local function tabline_format(opts)
--     local s = ""
--     for tabnr = 1, opts.tab_count do
--         s = s .. tab_format {
--             tabnr = tabnr;
--             is_current_tab = tabnr == opts.current_tabnr;
--         }
--     end
--     return s
-- end
--
-- function TabLine()
--     local opts = {
--         tab_count = vim.fn.tabpagenr('$');
--         current_tabnr = vim.fn.tabpagenr();
--     }
--     return tabline_format(opts)
-- end
--
--
-- vim.opt.showtabline = 2
-- vim.opt.tabline = "%!v:lua.TabLine()"
