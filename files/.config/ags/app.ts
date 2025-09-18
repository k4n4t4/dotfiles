import app from "ags/gtk4/app"

import style from "./style.scss"

import Bar from "./widget/Bar"
// import Popups from "./widget/Popups"
// import Media from "./widget/Media"
// import Notifications from "./widget/Notifications"
// import NotificationPopups from "./widget/NotificationPopups"


app.start({
  css: style,
  main() {
    app.get_monitors().map(m => {
      Bar(m)
      // Popups(m)
      // Media(m)
      // Notifications(m)
      // NotificationPopups(m)
    })
  },
})
