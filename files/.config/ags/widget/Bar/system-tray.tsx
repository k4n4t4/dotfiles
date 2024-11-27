import { Astal, Gdk } from "astal/gtk3"
import { bind, Variable } from "astal"

import Tray from "gi://AstalTray"


function BarSystemTrayItem(item: Tray.TrayItem): JSX.Element {
  const menu = item.create_menu()

  function onClick(self: Astal.Button, event: Astal.ClickEvent) {
    switch (event.button) {
      case Astal.MouseButton.PRIMARY:
        item?.activate(event.x, event.y)
        break
      case Astal.MouseButton.SECONDARY:
        menu?.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
        break
    }
  }

  return (
    <box className="bar-systemtray-item">
      <button onDestroy={() => menu?.destroy()} onClick={onClick} tooltip-markup={bind(item, 'tooltip_markup')}>
        <icon icon={bind(item, 'icon_name')} />
      </button>
    </box>
  )
}


export default function BarSystemTray(): JSX.Element {
  const tray = Tray.get_default()

  const system_tray_items = bind(tray, 'items').as(items => {
    const children = []
    for (const item of items) {
      children.push(BarSystemTrayItem(item))
    }
    return children
  })

  const class_names = bind(Variable.derive([
    bind(tray, 'items'),
  ], (items) => {
    const class_names = ["bar-systemtray"]
    if (items.length > 0) {
      class_names.push("bar-systemtray-exist")
    } else {
      class_names.push("bar-systemtray-empty")
    }
    return class_names.join(" ")
  }))

  return (
    <box className={class_names}>
      {system_tray_items}
    </box>
  )
}
