local M = {}


---@param lnum number
---@return boolean
function M.is_fold_start(lnum)
  if lnum == 1 and vim.fn.foldlevel(1) ~= 0 then
    return true
  else
    local winview = vim.fn.winsaveview()
    vim.b.lazyredraw = true

    vim.cmd "noautocmd normal kzj"
    local fold_lnum = vim.fn.line(".")

    vim.fn.winrestview(winview)
    vim.b.lazyredraw = false
    return fold_lnum == lnum
  end
end

---@param toprow number
---@param botrow number
---@return number[]
function M.get_fold_start(toprow, botrow)
  local winview = vim.fn.winsaveview()
  vim.b.lazyredraw = true
  local folds = {}

  vim.cmd("noautocmd normal " .. tostring(toprow) .. "G")

  local fold_lnum
  local pre_lnum
  if toprow == 1 and vim.fn.foldlevel(1) ~= 0 then
    fold_lnum = 1
    pre_lnum = 1
    table.insert(folds, fold_lnum)
  else
    vim.cmd "noautocmd normal k"
    pre_lnum = vim.fn.line(".")
  end

  while true do
    vim.cmd "noautocmd normal zj"
    fold_lnum = vim.fn.line(".")

    if fold_lnum == pre_lnum or fold_lnum >= botrow then break end

    pre_lnum = fold_lnum

    table.insert(folds, fold_lnum)
  end


  vim.fn.winrestview(winview)
  vim.b.lazyredraw = false
  return folds
end


return M
