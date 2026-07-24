import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import { createState, For, onCleanup, With, createBinding } from "ags"
import { timeout } from "ags/time"

import Notifd from "gi://AstalNotifd"

import GLib from "gi://GLib?version=2.0"
import Pango from "gi://Pango?version=1.0"


const TIMEOUT = 5000


function notificationIcon({ app_icon, desktop_entry, image }: Notifd.Notification): JSX.Element {
  let icon = 'dialog-information-symbolic'
  let child;

  if (image) {
    if (Astal.Icon.lookup_icon(image)) {
      child = (<image iconName={image} pixelSize={48} />)
    } else if (GLib.file_test(image, GLib.FileTest.EXISTS)) {
      child = (
        <box
          css={`
            background-image: url("${image}");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
            min-width: 48px;
            min-height: 48px;
          `}
        />
      )
    } else {
      child = (<image iconName={icon} pixelSize={48} />)
    }
  } else {
    if (app_icon || desktop_entry) {
      icon = app_icon || desktop_entry
    }
    child = (<image iconName={icon} pixelSize={48} />)
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

function NotificationPopup({ notification, onDismiss }: { notification: Notifd.Notification, onDismiss: () => void }): JSX.Element {
  const [isExpanded, setIsExpanded] = createState(false)
  
  const toggleExpanded = () => {
    setIsExpanded(!isExpanded.get())
  }
  
  const handleDismiss = (event: Astal.ClickEvent) => {
    notification.dismiss()
    onDismiss()
  }

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

  return (
    <box
      class={`notification-popup notification-popup-${notificationUrgency(notification.urgency)}`}
      orientation={Gtk.Orientation.VERTICAL}
    >
      <box>
        <button 
          class="notification-popup-expand-button"
          onClicked={toggleExpanded}
          hexpand
        >
          <box>
            {icon}
            <box orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.START}>
              {time}
              <With value={isExpanded}>
                {(expanded) => expanded ? (
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
                )}
              </With>
              <With value={isExpanded}>
                {(expanded) => expanded ? (
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
                )}
              </With>
            </box>
          </box>
        </button>
        <button
          class="notification-popup-close-button"
          onClicked={handleDismiss}
          valign={Gtk.Align.START}
        >
          <label label="✕" />
        </button>
      </box>
      {notification.actions.length > 0 && (
        <box class="notification-popup-actions">
          {notification.actions.map(action => (
            <button
              class="notification-popup-actions-button"
              onClicked={() => {
                notification.invoke(action.id)
                notification.dismiss()
                onDismiss()
              }}
              hexpand
            >
              <label label={action.label} />
            </button>
          ))}
        </box>
      )}
    </box>
  )
}


export default function NotificationPopups(gdkmonitor: Gdk.Monitor) {
  const notifd = Notifd.get_default()

  // Use binding like Notifications window
  const notifications = createBinding(notifd, 'notifications').as(notifs => 
    notifs.sort((a, b) => b.id - a.id)
  )

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
      visible={notifications.as(n => n.length > 0)}
    >
      <box 
        class="notification-popups"
        orientation={Gtk.Orientation.VERTICAL}
      >
        <For each={notifications}>
          {(notification) => (
            <NotificationPopup 
              notification={notification} 
              onDismiss={() => notification.dismiss()}
            />
          )}
        </For>
      </box>
    </window>
  )
}
