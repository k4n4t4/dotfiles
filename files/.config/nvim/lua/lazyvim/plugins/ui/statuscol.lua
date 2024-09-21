return {
  "luukvbaal/statuscol.nvim",
  enabled = true,
  config = function()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
      bt_ignore = { "terminal", "nofile", "ddu-ff", "ddu-ff-filter" },
      foldfunc = "buildin",
      relculright = true,
      setopt = true,

      segments = {
        {
          text = { "%s" }
        },
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 0,
            wrap = true,
          },
        },
        {
          text = { builtin.lnumfunc },
          condition = { true, builtin.not_empty },
        },
        {
          text = { builtin.foldfunc },
          hl = "FoldColumn",
        },
        {
          text = { "│" }
        },
      },
    }
  end
}
