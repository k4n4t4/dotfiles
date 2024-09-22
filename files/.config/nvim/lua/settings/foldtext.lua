function FoldText()
  local foldtext = ""
  local line = vim.fn.getline(vim.v.foldstart)

  foldtext = foldtext .. line .. " [" .. vim.v.foldlevel .. "] " .. vim.v.foldstart .. " - " .. vim.v.foldend .. " "
  return foldtext
end

-- vim.opt.foldtext = "v:lua.FoldText()"
vim.opt.foldtext = ""
