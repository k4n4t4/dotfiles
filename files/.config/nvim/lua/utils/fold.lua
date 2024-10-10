local M = {}


-- function M.get_folds(toprow, botrow)
--   local folds = {}
--   local winview = vim.fn.winsaveview()
--
--   local lnum = vim.fn.line(".")
--
--   local fold_start = vim.fn.foldclosed(lnum)
--   if fold_start == -1 then
--
--     vim.cmd.normal "zj"
--
--     vim.cmd.normal "]z"
--     local fold_end = vim.fn.line(".")
--     vim.cmd.normal "[z"
--     local fold_start = vim.fn.line(".")
--
--     print(lnum, fold_start, fold_end)
--
--   else
--
--     print(lnum, fold_start, fold_end)
--
--   end
--
--
--   -- vim.fn.winrestview(winview)
--   return folds
-- end


return M
