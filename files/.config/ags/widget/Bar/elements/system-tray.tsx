import { Astal, Gtk } from "ags/gtk4"
import { createBinding, createState } from "ags"

import Tray from "gi://AstalTray"

type systemtray_params = {
  reveal?: boolean
  show_items?: string[]
}


function BarSystemTrayItem(item: Tray.TrayItem): JSX.Element {
  return (
    <box>
      <menubutton
        class="bar-systemtray-item"
        tooltipMarkup={createBinding(item, 'tooltipMarkup')}
        usePopover={false}
        actionGroup={createBinding(item, 'actionGroup').as(ag => ['dbusmenu', ag])}
        menuModel={createBinding(item, 'menuModel')}>
        <icon gicon={createBinding(item, 'gicon')} />
      </menubutton>
    </box>
  )
}

export default function BarSystemTray(params: systemtray_params): JSX.Element {
  const tray = Tray.get_default()

  const reveal = createState(params.reveal || false)
  const show_items = params.show_items || []


  const system_tray_items = createBinding(tray, 'items').as(items => {

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
        <box class="bar-systemtray-reveal-button">
          <label label={createBinding(reveal).as(b => {
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
      <box class={"bar-systemtray bar-systemtray-" + (children.length + hide_children.length > 0 ? "exist" : "empty")}>
        <box class={"bar-systemtray-hide-items bar-systemtray-hide-items-" + (hide_children.length > 0 ? "exist" : "empty")}>
          <revealer
            transitionDuration={500}
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={createBinding(reveal)} >
            <box>
              {hide_children}
            </box>
          </revealer>
        </box>
        {reveal_button}
        <box class={"bar-systemtray-items bar-systemtray-items-" + (children.length > 0 ? "exist" : "empty")}>
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
