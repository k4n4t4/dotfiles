import { Astal, Gdk } from "astal/gtk3"
import { bind, Variable } from "astal"

import Tray from "gi://AstalTray"


function BarSystemTrayItem(item: Tray.TrayItem): JSX.Element {
  return (
    <box className="bar-systemtray-item">
      <menubutton
        tooltipMarkup={bind(item, "tooltipMarkup")}
        usePopover={false}
        actionGroup={bind(item, "action-group").as(ag => ["dbusmenu", ag])}
        menuModel={bind(item, "menu-model")}>
        <icon gicon={bind(item, "gicon")} />
      </menubutton>
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
