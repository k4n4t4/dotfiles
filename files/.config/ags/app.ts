import { App } from "astal/gtk3"

import style from "./style.scss"

import Bar from "./widget/Bar"
import Popups from "./widget/Popups"
import Media from "./widget/Media"
import Notifications from "./widget/Notifications"
import NotificationPopups from "./widget/NotificationPopups"


App.start({
  css: style,
  main() {
    App.get_monitors().map(Bar)
    App.get_monitors().map(Popups)
    App.get_monitors().map(Media)
    App.get_monitors().map(Notifications)
    App.get_monitors().map(NotificationPopups)
  },
})
