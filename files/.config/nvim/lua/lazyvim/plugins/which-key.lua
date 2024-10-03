return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = 'modern',
    delay = function(ctx)
      return ctx.plugin and 0 or 500
    end,
    win = {
      border = "single",
    },
  },
  keys = {
    {
      mode = "n",
      "<LEADER>?",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "Which Key"
    },
  }
}
