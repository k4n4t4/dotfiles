return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                   ]],
      [[█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█]],
      [[█ █◣  █             █   █         █]],
      [[█ █◥◣ █ ▄▄▄▄▄ █▀▀▀█ █   █ ▀ ▄▄▄▄▄ █]],
      [[█ █ ◥◣█ █▄▄▄█ █   █ ◥◣ ◢◤ █ █ █ █ █]],
      [[█ █  ◥█ █▄▄▄▄ █▄▄▄█  ◥█◤  █ █ █ █ █]],
      [[█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█]],
      (function()
        local space = [[NeoVim                             ]]

        local version = vim.version()
        local format = {
          "Version ",
          version.major,
          ".",
          version.minor,
          ".",
          version.patch,
        }
        local str = table.concat(format, "")

        if #space < #str then
          return str
        end
        return string.sub(space, 1, #space - #str) .. str
      end)(),
    }

    dashboard.section.buttons.val = {
      dashboard.button("n", "  New File", "<CMD>enew<CR>"),
      dashboard.button("r", "  Recent File", "<CMD>Telescope oldfiles<CR>"),
      dashboard.button("f", "󰈞  Find File", "<CMD>Telescope find_files<CR>"),
      dashboard.button("g", "󱎸  Find Text", "<CMD>Telescope live_grep<CR>"),
      dashboard.button("t", "  Projects", "<CMD>Telescope project<CR>"),
      dashboard.button("p", "  Plugins", "<CMD>Lazy<CR>"),
      dashboard.button("u", "  Update Plugins", "<CMD>Lazy sync<CR>"),
      dashboard.button("s", "  Settings", "<CMD>e $MYVIMRC<CR><CMD>silent :cd %:p:h<CR>"),
      dashboard.button("q", "  Quit", "<CMD>qa<CR>"),
    }
    dashboard.section.buttons.opts = {
      cursor = 0,
      spacing = 1,
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
  event = 'VimEnter',
}
