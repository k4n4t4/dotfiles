import { Astal, Gtk } from "astal/gtk3"
import { bind, Variable } from "astal"

import Tray from "gi://AstalTray"

type systemtray_params = {
  reveal?: boolean
  show_items?: string[]
}


function BarSystemTrayItem(item: Tray.TrayItem): JSX.Element {
  return (
    <box>
      <menubutton
        className="bar-systemtray-item"
        tooltipMarkup={bind(item, 'tooltipMarkup')}
        usePopover={false}
        actionGroup={bind(item, 'actionGroup').as(ag => ['dbusmenu', ag])}
        menuModel={bind(item, 'menuModel')}>
        <icon gicon={bind(item, 'gicon')} />
      </menubutton>
    </box>
  )
}

export default function BarSystemTray(params: systemtray_params): JSX.Element {
  const tray = Tray.get_default()

  const reveal = Variable(params.reveal || false)
  const show_items = params.show_items || []


  const system_tray_items = bind(tray, 'items').as(items => {

    const children = []
    const hide_children = []

    for (const item of items) {
      if (show_items.includes(item.title)) {
        children.push(BarSystemTrayItem(item))
      } else {
        hide_children.push(BarSystemTrayItem(item))
      }
    }

    function onClick(_self: Astal.EventBox, event: Astal.ClickEvent) {
      switch (event.button) {
        case Astal.MouseButton.PRIMARY:
        case Astal.MouseButton.SECONDARY:
          reveal.set(!reveal.get())
          break
      }
    }

    const reveal_button = hide_children.length > 0 ? (
      <eventbox onClick={onClick}>
        <box className="bar-systemtray-reveal-button">
          <label label={bind(reveal).as(b => {
            if (b) {
              return " "
            } else {
              return " "
            }
          })} />
        </box>
      </eventbox>
    ) : (
      <box />
    )

    return (
      <box className={"bar-systemtray bar-systemtray-" + (children.length + hide_children.length > 0 ? "exist" : "empty")}>
        <box className={"bar-systemtray-hide-items bar-systemtray-hide-items-" + (hide_children.length > 0 ? "exist" : "empty")}>
          <revealer
            transitionDuration={500}
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={bind(reveal)} >
            {hide_children}
          </revealer>
        </box>
        {reveal_button}
        <box className={"bar-systemtray-items bar-systemtray-items-" + (children.length > 0 ? "exist" : "empty")}>
          {children}
        </box>
      </box>
    )
  })


  return (
    <box>
      {system_tray_items}
    </box>
  )
}
