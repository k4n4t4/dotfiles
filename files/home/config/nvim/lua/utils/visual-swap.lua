local M = {}

local ns_id = vim.api.nvim_create_namespace("VisualSwap")


local function get_text(bufnr, r)
  return vim.api.nvim_buf_get_text(bufnr, r[1], r[2], r[3], r[4], {})
end

local function set_text(bufnr, r, lines)
  vim.api.nvim_buf_set_text(bufnr, r[1], r[2], r[3], r[4], lines)
end

local function extmark_range(bufnr, r)
  local a = vim.api.nvim_buf_set_extmark(bufnr, ns_id, r[1], r[2], { right_gravity = false })
  local b = vim.api.nvim_buf_set_extmark(bufnr, ns_id, r[3], r[4], { right_gravity = true })
  return a, b
end

local function resolve_range(bufnr, a, b)
  local pa = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns_id, a, {})
  local pb = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns_id, b, {})
  return { pa[1], pa[2], pb[1], pb[2] }
end

function M.swap(bufnr1, range1, bufnr2, range2)
  local text1 = get_text(bufnr1, range1)
  local text2 = get_text(bufnr2, range2)

  local m1a, m1b = extmark_range(bufnr1, range1)
  local m2a, m2b = extmark_range(bufnr2, range2)

  set_text(bufnr1, resolve_range(bufnr1, m1a, m1b), text2)
  set_text(bufnr2, resolve_range(bufnr2, m2a, m2b), text1)

  vim.api.nvim_buf_del_extmark(bufnr1, ns_id, m1a)
  vim.api.nvim_buf_del_extmark(bufnr1, ns_id, m1b)
  vim.api.nvim_buf_del_extmark(bufnr2, ns_id, m2a)
  vim.api.nvim_buf_del_extmark(bufnr2, ns_id, m2b)
end

function M.visual_range(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local s = vim.fn.getpos('v')
  local e = vim.fn.getpos('.')
  local s_row, s_col = s[2] - 1, s[3] - 1
  local e_row, e_col = e[2] - 1, e[3] - 1
  if s_row > e_row or (s_row == e_row and s_col > e_col) then
    s_row, s_col, e_row, e_col = e_row, e_col, s_row, s_col
  end
  local line = vim.api.nvim_buf_get_lines(bufnr, e_row, e_row + 1, false)[1] or ""
  e_col = math.min(e_col + 1, #line)
  return { s_row, s_col, e_row, e_col }
end

return M
