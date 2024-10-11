return {
  "luukvbaal/statuscol.nvim",
  enabled = false,
  config = function()
    local builtin = require("statuscol.builtin")
    vim.opt.foldcolumn = '1'
    require("statuscol").setup({
      segments = {
        { text = { "%s" } },
        { text = { builtin.lnumfunc } },
        { text = { builtin.foldfunc } },
        { text = { "│" } },
      }
    })
  end,
  event = 'VeryLazy',
}
