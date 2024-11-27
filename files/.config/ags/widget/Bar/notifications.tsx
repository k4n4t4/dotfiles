import { App, Astal } from "astal/gtk3"
import { bind } from "astal"

import Notifd from "gi://AstalNotifd"


export default function BarNotifications(): JSX.Element {
  const notifd = Notifd.get_default()

  const class_name = bind(notifd, 'notifications').as(n => {
    const class_names = ["bar-notifications"]
    if (n.length > 0) {
      class_names.push("bar-notifications-exist")
    }
    return class_names.join(" ")
  })

  const tooltip_text = bind(notifd, 'notifications').as(n => `${n.length}`)

  function onClick(_self: Astal.EventBox, event: Astal.ClickEvent) {
    switch (event.button) {
      case Astal.MouseButton.PRIMARY:
        App.toggle_window("Notifications")
        break
      case Astal.MouseButton.SECONDARY:
        // todo
        break
    }
  }

  return (
    <eventbox onClick={onClick}>
      <box className={class_name} >
        <label tooltipText={tooltip_text} label={" "} />
      </box>
    </eventbox>
  )
}
