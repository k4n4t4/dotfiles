import { Gdk, Gtk } from "ags/gtk4"
import { createBinding, createState, With } from "ags"

import Tray from "gi://AstalTray"

type systemtray_params = {
  reveal?: boolean
  show_items?: string[]
}


function BarSystemTrayItem(item: Tray.TrayItem): JSX.Element {
  let popovermenu: Gtk.PopoverMenu

  return (
    <box
      class="item"
      $={(self) => {
        const visibleConn = popovermenu.connect("notify::visible", ({ visible }) =>
          self[visible ? "add_css_class" : "remove_css_class"]("active")
        )

        self.connect("destroy", () => {
          popovermenu.disconnect(visibleConn)
        })
      }}
    >
      <image
        class="tray-icon"
        $={(self) => {
          const updateIcon = () => {
            self.gicon = item.gicon
          }
          updateIcon()
          const iconConn = item.connect("notify::gicon", updateIcon)
          
          const updateTooltip = () => {
            self.tooltipMarkup = item.tooltipMarkup || ""
          }
          updateTooltip()
          const tooltipConn = item.connect("notify::tooltip-markup", updateTooltip)
          
          self.connect("destroy", () => {
            item.disconnect(iconConn)
            item.disconnect(tooltipConn)
          })
        }}
      />
      <Gtk.GestureClick
        onPressed={() => item.about_to_show()}
        onReleased={(ctrl, _, x, y) => {
          const button = ctrl.get_current_button()
          if (button === Gdk.BUTTON_PRIMARY) {
            item.activate(x, y)
          } else if (button === Gdk.BUTTON_SECONDARY) {
            if (popovermenu) {
              if (popovermenu.visible) {
                popovermenu.popdown()
              } else {
                popovermenu.popup()
              }
            }
          } else if (button === Gdk.BUTTON_MIDDLE) {
            item.secondary_activate(x, y)
          }
        }}
        button={0}
      />
      <Gtk.PopoverMenu
        menuModel={item.menuModel}
        position={Gtk.PositionType.BOTTOM}
        $={(self) => {
          popovermenu = self
          self.insert_action_group("dbusmenu", item.actionGroup)

          const conns = [
            item.connect("notify::action-group", (item) => {
              self.insert_action_group("dbusmenu", item.actionGroup)
            }),

            item.connect("notify::menu-model", (item) => {
              self.set_menu_model(item.menuModel)
            }),
          ]

          self.connect("destroy", () => {
            conns.forEach((id) => item.disconnect(id))
          })
        }}
      />
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
        <box class="reveal-button">
          <label label={reveal.as(b => b ? " " : " ")} />
        </box>
      </button>
    ) : (
      <box />
    )

    return (
      // TODO: string to accesser
      <box class={children.length + hide_children.length > 0 ? "exist" : "empty"}>
        <box class={"hide-items hide-items-" + (hide_children.length > 0 ? "exist" : "empty")}>
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
        <box class={"items items-" + (children.length > 0 ? "exist" : "empty")}>
          {children}
        </box>
      </box>
    )
  })


  return (
    <box class="systemtray">
      <With value={system_tray_items}>
        {system_tray_items => system_tray_items}
      </With>
    </box>
  )
}
