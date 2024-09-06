local lousy = require "lousy"
lousy.theme.init(lousy.util.find_config("theme.lua"))
assert(lousy.theme.get(), "failed to load theme")



-- Downloads

local downloads = require "downloads"
require "downloads_chrome"

downloads.default_dir = os.getenv("HOME") .. "/tmp"
downloads.add_signal("download-location", function (uri, file)
  if not file or file == "" then
    file = ( string.match(uri, "/([^/]+)$") or
      string.match(uri, "^%w+://(.+)") or
      string.gsub(uri, "/", "_") or "untitled")
  end
  return downloads.default_dir .. "/" .. file
end)


-- Settings





local window = require "window"
local log_chrome = require "log_chrome"

window.add_signal("build", function (w)
    local widgets, l, r = require "lousy.widget", w.sbar.l, w.sbar.r

    l.layout:pack(widgets.uri())
    l.layout:pack(widgets.hist())
    l.layout:pack(widgets.progress())

    r.layout:pack(widgets.buf())
    r.layout:pack(log_chrome.widget())
    r.layout:pack(widgets.ssl())
    r.layout:pack(widgets.tabi())
    r.layout:pack(widgets.scroll())
end)

require "modes"
require "binds"

window.new()
