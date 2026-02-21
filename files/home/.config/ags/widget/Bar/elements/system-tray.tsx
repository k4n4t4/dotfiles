import { Gdk, Gtk } from "ags/gtk4"
import { createBinding, createState, For, onCleanup } from "ags"

import Tray from "gi://AstalTray"

type systemtray_params = {
  reveal?: boolean
  show_items?: string[]
}

export default function BarSystemTray(params: systemtray_params): JSX.Element {
  const tray = Tray.get_default()
  const [reveal, setReveal] = createState(params.reveal || false)
  const show_items = params.show_items || []

  const items = createBinding(tray, 'items').as(items =>
    items.filter((item) => item.id !== null)
  )

  const visibleItems = createBinding(tray, 'items').as(items => {
    if (show_items.length === 0) return items.filter((item) => item.id !== null)
    return items.filter((item) => item.id !== null && show_items.includes(item.title))
  })

  const hiddenItems = createBinding(tray, 'items').as(items => {
    if (show_items.length === 0) return []
    return items.filter((item) => item.id !== null && !show_items.includes(item.title))
  })

  const content = (
    <box class="items">
      <For each={visibleItems}>
        {(item) => {
          let popovermenu: Gtk.PopoverMenu

          return (
            <box
              class="item"
              $={(self) => {
                popovermenu.connect("notify::visible", ({ visible }) =>
                  self[visible ? "add_css_class" : "remove_css_class"]("active")
                )
              }}
            >
              <image
                class="tray-icon"
                gicon={createBinding(item, "gicon")}
                tooltipMarkup={createBinding(item, "tooltipMarkup")}
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

                  onCleanup(() => {
                    conns.forEach((id) => item.disconnect(id))
                  })
                }}
              />
            </box>
          )
        }}
      </For>
    </box>
  )

  const hiddenContent = (
    <box class="hide-items">
      <For each={hiddenItems}>
        {(item) => {
          let popovermenu: Gtk.PopoverMenu

          return (
            <box
              class="item"
              $={(self) => {
                popovermenu.connect("notify::visible", ({ visible }) =>
                  self[visible ? "add_css_class" : "remove_css_class"]("active")
                )
              }}
            >
              <image
                class="tray-icon"
                gicon={createBinding(item, "gicon")}
                tooltipMarkup={createBinding(item, "tooltipMarkup")}
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

                  onCleanup(() => {
                    conns.forEach((id) => item.disconnect(id))
                  })
                }}
              />
            </box>
          )
        }}
      </For>
    </box>
  )

  const hasHiddenItems = createBinding(tray, 'items').as(items => {
    if (show_items.length === 0) return false
    return items.some((item) => item.id !== null && !show_items.includes(item.title))
  })

  return (
    <box class="systemtray">
      <box class={items.as(items => items.length > 0 ? "exist" : "empty")}>
        <revealer
          transitionDuration={500}
          transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
          revealChild={reveal}
        >
          {hiddenContent}
        </revealer>
        <button 
          visible={hasHiddenItems}
          tooltipText={reveal.as(b => b ? "hide" : "show")}
          onClicked={() => setReveal(!reveal.get())}
        >
          <box class="reveal-button">
            <image iconName={reveal.as(b => b ? "pan-end-symbolic" : "pan-start-symbolic")} />
          </box>
        </button>
        {content}
      </box>
    </box>
  )
}
