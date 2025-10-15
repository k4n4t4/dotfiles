import app from "ags/gtk4/app"
import { createBinding } from "ags"

import Notifd from "gi://AstalNotifd"


export default function() {
  const notifd = Notifd.get_default()

  const class_names = createBinding(notifd, 'notifications').as(n => {
    const class_names = []
    if (n.length > 0) {
      class_names.push("exist")
    }
    return class_names
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
    <button class="notifications" onClicked={() => app.toggle_window("Notifications")}>
      <label cssClasses={class_names} tooltipText={tooltip_text} label={icon} />
    </button>
  )
}
