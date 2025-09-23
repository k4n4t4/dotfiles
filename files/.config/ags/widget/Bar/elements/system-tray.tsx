import { Gtk } from "ags/gtk4"
import { createBinding, createState, With } from "ags"

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
        menuModel={createBinding(item, 'menuModel')}
        iconName={createBinding(item, 'iconName')}>
      </menubutton>
    </box>
  )
}

export default function BarSystemTray(params: systemtray_params): JSX.Element {
  const tray = Tray.get_default()

  const [reveal, setReveal] = createState(params.reveal || false)
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

    const reveal_button = hide_children.length > 0 ? (
      <button onClicked={() => setReveal(!reveal.get())}>
        <box class="bar-systemtray-reveal-button">
          <label label={reveal.as(b => {
            if (b) {
              return " "
            } else {
              return " "
            }
          })} />
        </box>
      </button>
    ) : (
      <box />
    )

    return (
      <box class={"bar-systemtray bar-systemtray-" + (children.length + hide_children.length > 0 ? "exist" : "empty")}>
        <box class={"bar-systemtray-hide-items bar-systemtray-hide-items-" + (hide_children.length > 0 ? "exist" : "empty")}>
          <revealer
            transitionDuration={500}
            transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
            revealChild={reveal} >
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
      <With value={system_tray_items}>
        {system_tray_items => system_tray_items}
      </With>
    </box>
  )
}
