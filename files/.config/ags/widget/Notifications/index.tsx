import { App, Astal, Gdk, Gtk } from "astal/gtk3"
import { Variable, bind, GLib } from "astal"

import Notifd from "gi://AstalNotifd"


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

function Notification(notification: Notifd.Notification, setup: (self: JSX.Element) => void): JSX.Element {
  const truncate = Variable(true)

  const title = (
    <label
      className="notification-title"
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
      className="notification-body"
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
      className="notification-time"
      label={`${(new Date(notification.time * 1000)).toLocaleString()}`}
      hexpand
      use_markup
      halign={Gtk.Align.START}
    />
  )

  const icon = (
    <box
      className="notification-icon"
      tooltipText={notification.app_name}
      expand
    >
      {notificationIcon(notification)}
    </box>
  )

  const actions = (
    <box
      className="notification-actions"
    >
      {notification.actions.map(action => {
        function onClick() {
          notification.invoke(action.id)
          notification.dismiss()
        }
        return (
          <button
            className="notification-actions-button"
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
        className={`notification notification-${notificationUrgency(notification.urgency)}`}
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


export default function Notifications(gdkmonitor: Gdk.Monitor) {
  const notifd = Notifd.get_default()

  const notifications = bind(notifd, 'notifications').as(notifications => {
    const children: JSX.Element[] = []

    for (const notification of notifications.sort((a, b) => b.id - a.id)) {
      children.push(Notification(notification, () => {}))
    }

    return children
  })

  return (
    <window
      name="Notifications"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.NORMAL}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.RIGHT
      }
      layer={Astal.Layer.OVERLAY}
      application={App}
      visible={false}
    >
      <box className="notifications">
        <scrollable
          vscroll={Gtk.PolicyType.AUTOMATIC}
          hscroll={Gtk.PolicyType.AUTOMATIC}
        >
          <box vertical>
            {notifications}
          </box>
        </scrollable>
      </box>
    </window>
  )
}
