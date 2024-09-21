return {
  "luukvbaal/statuscol.nvim",
  enabled = true,
  config = function()
    local builtin = require "statuscol.builtin"
    require("statuscol").setup {
      bt_ignore = { "terminal", "nofile", "ddu-ff", "ddu-ff-filter" },
      foldfunc = "buildin",
      setopt = true,

      relculright = true,
      segments = {
        {
          sign = {
            name = { "Diagnostic.*" },
            maxwidth = 1,
          },
        },
        {
          sign = {
            namespace = { "gitsigns" },
            maxwidth = 1,
            colwidth = 1,
            wrap = true,
          },
        },
        {
          text = { builtin.lnumfunc },
          condition = { true, builtin.not_empty },
        },
        {
          text = { " " }
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
