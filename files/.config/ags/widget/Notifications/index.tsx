import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import { createBinding, createState } from "ags"

import Notifd from "gi://AstalNotifd"
import GLib from "gi://GLib?version=2.0"


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
  const truncate = createState(true)

  const title = (
    <label
      class="notification-title"
      tooltipText={notification.summary}
      label={notification.summary}
      max-width-char={30}
      hexpand
      use_markup
      truncate={createBinding(truncate)}
      halign={Gtk.Align.START}
    />
  )

  const body = (
    <label
      class="notification-body"
      label={notification.body}
      max-width-char={30}
      hexpand
      use_markup
      truncate={createBinding(truncate)}
      halign={Gtk.Align.START}
    />
  )

  const time = (
    <label
      class="notification-time"
      label={`${(new Date(notification.time * 1000)).toLocaleString()}`}
      hexpand
      use_markup
      halign={Gtk.Align.START}
    />
  )

  const icon = (
    <box
      class="notification-icon"
      tooltipText={notification.app_name}
      expand
    >
      {notificationIcon(notification)}
    </box>
  )

  const actions = (
    <box
      class="notification-actions"
    >
      {notification.actions.map(action => {
        function onClick() {
          notification.invoke(action.id)
          notification.dismiss()
        }
        return (
          <button
            class="notification-actions-button"
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
        class={`notification notification-${notificationUrgency(notification.urgency)}`}
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

  const notifications = createBinding(notifd, 'notifications').as(notifications => {
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
      application={app}
      visible={false}
    >
      <box class="notifications">
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
