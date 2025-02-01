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
    App.get_monitors().map(m => {
      Bar(m)
      Popups(m)
      Media(m)
      Notifications(m)
      NotificationPopups(m)
    })
  },
})
