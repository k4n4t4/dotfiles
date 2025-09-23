import app from "ags/gtk4/app"
import { createBinding } from "ags"

import Notifd from "gi://AstalNotifd"


export default function BarNotifications(): JSX.Element {
  const notifd = Notifd.get_default()

  const class_name = createBinding(notifd, 'notifications').as(n => {
    const class_names = ["bar-notifications"]
    if (n.length > 0) {
      class_names.push("bar-notifications-exist")
    }
    return class_names.join(" ")
  })

  const tooltip_text = createBinding(notifd, 'notifications').as(n => `${n.length}`)

  const icon = createBinding(notifd, 'notifications').as(n => {
    if (n.length > 0) {
      return " "
    } else {
      return " "
    }
  })

  return (
    <button onClicked={() => app.toggle_window("Notifications")}>
      <box class={class_name} >
        <label tooltipText={tooltip_text} label={icon} />
      </box>
    </button>
  )
}
