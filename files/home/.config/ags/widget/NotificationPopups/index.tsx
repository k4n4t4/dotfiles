import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import { Accessor, createState, For, State, createBinding } from "ags"
import { timeout } from "ags/time"

import Notifd from "gi://AstalNotifd"

import GLib from "gi://GLib?version=2.0"
import GObject from "gnim/gobject"
import Pango from "gi://Pango?version=1.0"


const TIMEOUT = 5000


function notificationIcon({ app_icon, desktop_entry, image }: Notifd.Notification): GObject.Object {
  let icon = 'dialog-information-symbolic'
  let child;

  if (image) {
    if (Astal.Icon.lookup_icon(image)) {
      child = (<image iconName={image} />)
    } else if (GLib.file_test(image, GLib.FileTest.EXISTS)) {
      child = (
        <box
          css={`
            background-image: url("${image}");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
          `}
        />
      )
    } else {
      child = (<image iconName={icon} />)
    }
  } else {
    if (app_icon || desktop_entry) {
      icon = app_icon || desktop_entry
    }
    child = (<image iconName={icon} />)
  }

  return child
}

function notificationUrgency(urgency: Notifd.Urgency): string {
  switch (urgency) {
    case Notifd.Urgency.LOW: return 'low'
    case Notifd.Urgency.NORMAL: return 'normal'
    case Notifd.Urgency.CRITICAL: return 'critical'
    default: return 'unknown'
  }
}

function NotificationPopup(notification: Notifd.Notification, isExpanded: boolean, toggleExpanded: () => void): GObject.Object {
  const title = isExpanded ? (
    <label
      class="notification-popup-title"
      tooltipText={notification.summary}
      label={notification.summary}
      hexpand
      use_markup
      wrap
      halign={Gtk.Align.START}
    />
  ) : (
    <label
      class="notification-popup-title"
      tooltipText={notification.summary}
      label={notification.summary}
      max_width_chars={30}
      hexpand
      use_markup
      ellipsize={Pango.EllipsizeMode.END}
      halign={Gtk.Align.START}
    />
  )

  const body = isExpanded ? (
    <label
      class="notification-popup-body"
      label={notification.body}
      hexpand
      use_markup
      wrap
      halign={Gtk.Align.START}
    />
  ) : (
    <label
      class="notification-popup-body"
      label={notification.body}
      max_width_chars={30}
      hexpand
      use_markup
      ellipsize={Pango.EllipsizeMode.END}
      halign={Gtk.Align.START}
    />
  )

  const time = (
    <label
      class="notification-popup-time"
      label={`${(new Date(notification.time * 1000)).toLocaleString()}`}
      hexpand
      use_markup
      halign={Gtk.Align.START}
    />
  )

  const icon = (
    <box
      class="notification-popup-icon"
      tooltipText={notification.app_name}
    >
      {notificationIcon(notification)}
    </box>
  )

  const actions = (
    <box
      class="notification-popup-actions"
    >
      {notification.actions.map(action => {
        function onClicked() {
          notification.invoke(action.id)
          notification.dismiss()
        }
        return (
          <button
            class="notification-popup-actions-button"
            onClicked={onClicked}
            hexpand
          >
            <label label={action.label} />
          </button>
        )
      })}
    </box>
  )


  function onDismiss(event: Astal.ClickEvent) {
    event.stopPropagation()
    notification.dismiss()
  }

  return (
    <button
      onClicked={toggleExpanded}
    >
      <box
        class={`notification-popup notification-popup-${notificationUrgency(notification.urgency)}`}
      >
        <box>
          {icon}
          <box halign={Gtk.Align.START}>
            {time}
            {title}
            {body}
          </box>
          <button
            class="notification-popup-close-button"
            onClicked={onDismiss}
            valign={Gtk.Align.START}
          >
            <label label="✕" />
          </button>
        </box>
        {actions}
      </box>
    </button>
  )
}


export default function NotificationPopups(gdkmonitor: Gdk.Monitor) {
  const notifd = Notifd.get_default()

  const popupMap = new Map<number, GObject.Object>()
  const expandedMap = new Map<number, boolean>()
  const [popups, setPopups] = createState<GObject.Object[]>([])

  function update() {
    setPopups([...popupMap.values()].reverse())
  }

  function delPopup(id: number) {
    popupMap.get(id)?.destroy()
    popupMap.delete(id)
    expandedMap.delete(id)
    update()
  }

  function setPopup(id: number, widget: GObject.Object) {
    popupMap.get(id)?.destroy()
    popupMap.set(id, widget)
    update()
  }

  function rebuildPopup(id: number) {
    const notification = notifd.get_notification(id)
    if (!notification) return
    
    const isExpanded = expandedMap.get(id) || false
    const toggleExpanded = () => {
      expandedMap.set(id, !isExpanded)
      rebuildPopup(id)
    }
    
    const widget = NotificationPopup(notification, isExpanded, toggleExpanded)
    setPopup(id, widget)
    
    // Auto dismiss after TIMEOUT
    timeout(TIMEOUT, () => {
      if (popupMap.has(id)) {
        delPopup(id)
      }
    })
  }

  notifd.connect('notified', (_, id) => {
    expandedMap.set(id, false)
    rebuildPopup(id)
  })

  notifd.connect('resolved', (_, id) => {
    delPopup(id)
  })


  return (
    <window
      name="NotificationPopups"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.RIGHT
      }
      application={app}
      layer={Astal.Layer.OVERLAY}
    >
      <box class="notification-popups">
        <For each={popups}>
          {v => v}
        </For>
      </box>
    </window>
  )
}
