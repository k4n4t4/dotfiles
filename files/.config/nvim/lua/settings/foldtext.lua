function FoldText()
  local foldtext = ""
  local line = vim.fn.getline(vim.v.foldstart)

  foldtext = foldtext .. line
  foldtext = foldtext .. " [" .. vim.v.foldlevel .. "] "
  foldtext = foldtext .. vim.v.foldstart .. " - " .. vim.v.foldend .. " "

  return foldtext
end

-- vim.opt.foldtext = "v:lua.FoldText()"
vim.opt.foldtext = ""
