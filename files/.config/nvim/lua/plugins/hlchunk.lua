return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    chunk = {
      enable = true,
      delay = 0,
    },
    indent = {
      enable = false
    },
    line_num = {
      enable = true
    },
    blank = {
      enable = false
    },
  }
}
