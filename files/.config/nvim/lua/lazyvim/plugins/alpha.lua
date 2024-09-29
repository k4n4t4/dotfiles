return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim"
  },
  enabled = true,
  event = "VimEnter",
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[█◣  █             █   █        ]],
      [[█◥◣ █ ▄▄▄▄▄ █▀▀▀█ █   █ ▀ ▄▄▄▄▄]],
      [[█ ◥◣█ █▄▄▄█ █   █ ◥◣ ◢◤ █ █ █ █]],
      [[█  ◥█ █▄▄▄▄ █▄▄▄█  ◥█◤  █ █ █ █]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("r", "  Recent file", ":Telescope oldfiles <CR>"),
      dashboard.button("f", "󰥨  Find file", ":Telescope find_files <CR>"),
      dashboard.button("g", "󰱼  Find text", ":Telescope live_grep <CR>"),
      dashboard.button("s", "  Settings", ":e $MYVIMRC | :cd %:p:h <CR>"),
      dashboard.button("q", "  Quit", ":qa<CR>"),
    }
    dashboard.section.buttons.opts = {
      spacing = 0,
    }

    vim.api.nvim_create_autocmd("User", {
      pattern = "AlphaReady",
      callback = function()
        vim.opt.laststatus = 0
        vim.opt.showtabline = 0
      end
    })
    vim.api.nvim_create_autocmd("BufUnload", {
      pattern = "<buffer>",
      callback = function()
        vim.opt.laststatus = 2
        vim.opt.showtabline = 1
      end
    })

    require("alpha").setup(dashboard.config)

    vim.cmd [[ autocmd FileType alpha setlocal nofoldenable ]]
  end,
}
