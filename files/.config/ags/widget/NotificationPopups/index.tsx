import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind, timeout, GLib } from "astal"

import Notifd from "gi://AstalNotifd"


const TIMEOUT = 5000


function notificationIcon({ app_icon, desktop_entry, image }: Notifd.Notification): JSX.Element {
  let icon = 'dialog-information-symbolic'
  let child;

  if (image) {
    if (Astal.Icon.lookup_icon(image)) {
      child = (<icon expand icon={image} />)
    } else if (GLib.file_test(image, GLib.FileTest.EXISTS)) {
      child = (
        <box
          expand
          css={`
            background-image: url("${image}");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
          `}
        />
      )
    } else {
      child = (<icon expand icon={icon} />)
    }
  } else {
    if (app_icon || desktop_entry) {
      icon = app_icon || desktop_entry
    }
    child = (<icon expand icon={icon} />)
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

function NotificationPopup(notification: Notifd.Notification, setup: (self: JSX.Element) => void): JSX.Element {
  const truncate = Variable(true)

  const title = (
    <label
      className="notification-popup-title"
      tooltipText={notification.summary}
      label={notification.summary}
      max-width-char={30}
      hexpand
      use_markup
      truncate={bind(truncate)}
      halign={Gtk.Align.START}
    />
  )

  const body = (
    <label
      className="notification-popup-body"
      label={notification.body}
      max-width-char={30}
      hexpand
      use_markup
      truncate={bind(truncate)}
      halign={Gtk.Align.START}
    />
  )

  const time = (
    <label
      className="notification-popup-time"
      label={`${(new Date(notification.time * 1000)).toLocaleString()}`}
      hexpand
      use_markup
      halign={Gtk.Align.START}
    />
  )

  const icon = (
    <box
      className="notification-popup-icon"
      tooltipText={notification.app_name}
      expand
    >
      {notificationIcon(notification)}
    </box>
  )

  const actions = (
    <box
      className="notification-popup-actions"
    >
      {notification.actions.map(action => {
        function onClick() {
          notification.invoke(action.id)
          notification.dismiss()
        }
        return (
          <button
            className="notification-popup-actions-button"
            onClick={onClick}
            hexpand
          >
            <label label={action.label} />
          </button>
        )
      })}
    </box>
  )


  function onClick(_self: Astal.EventBox, event: Astal.ClickEvent) {
    switch (event.button) {
      case Astal.MouseButton.PRIMARY:
        notification.dismiss()
        break
      case Astal.MouseButton.SECONDARY:
        truncate.set(!truncate.get())
        break
    }
  }

  return (
    <eventbox
      onClick={onClick}
      setup={setup}
    >
      <box
        className={`notification-popup notification-popup-${notificationUrgency(notification.urgency)}`}
        vertical
      >
        <box>
          {icon}
          <box vertical halign={Gtk.Align.START}>
            {time}
            {title}
            {body}
          </box>
        </box>
        {actions}
      </box>
    </eventbox>
  )
}


export default function NotificationPopups(gdkmonitor: Gdk.Monitor) {
  const notifd = Notifd.get_default()

  const popupMap: Map<number, JSX.Element> = new Map()
  const popups: Variable<JSX.Element[]> = Variable([])

  function update() {
    popups.set([...popupMap.values()].reverse())
  }

  function delPopup(id: number) {
    popupMap.get(id)?.destroy()
    popupMap.delete(id)
    update()
  }

  function setPopup(id: number, widget: JSX.Element) {
    popupMap.get(id)?.destroy()
    popupMap.set(id, widget)
    update()
  }

  notifd.connect('notified', (_, id) => {
    setPopup(
      id,
      NotificationPopup(notifd.get_notification(id)!, _self => {
        timeout(TIMEOUT, () => {
          delPopup(id)
        })
      })
  )})

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
      application={App}
    >
      <box vertical className="notification-popups">
        {bind(popups)}
      </box>
    </window>
  )
}
