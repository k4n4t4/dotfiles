import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import { createState, For, onCleanup, createBinding } from "ags"

import Notifd from "gi://AstalNotifd"
import GLib from "gi://GLib?version=2.0"
import Pango from "gi://Pango?version=1.0"


function notificationIcon({ app_icon, desktop_entry, image }: Notifd.Notification): JSX.Element {
  let icon = 'dialog-information-symbolic'
  let child;

  if (image) {
    if (Astal.Icon.lookup_icon(image)) {
      child = (<image hexpand vexpand iconName={image} pixelSize={48} />)
    } else if (GLib.file_test(image, GLib.FileTest.EXISTS)) {
      child = (
        <box
          hexpand
          vexpand
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
      child = (<image hexpand vexpand iconName={icon} pixelSize={48} />)
    }
  } else {
    if (app_icon || desktop_entry) {
      icon = app_icon || desktop_entry
    }
    child = (<image hexpand vexpand iconName={icon} pixelSize={48} />)
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

function Notification({ notification, isExpanded, toggleExpanded, onClose }: { notification: Notifd.Notification, isExpanded: boolean, toggleExpanded: () => void, onClose: () => void }): JSX.Element {
  const title = isExpanded ? (
    <label
      class="notification-title"
      tooltipText={notification.summary}
      label={notification.summary}
      hexpand
      use_markup
      wrap
      halign={Gtk.Align.START}
    />
  ) : (
    <label
      class="notification-title"
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
      class="notification-body"
      label={notification.body}
      hexpand
      use_markup
      wrap
      halign={Gtk.Align.START}
    />
  ) : (
    <label
      class="notification-body"
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
      hexpand
      vexpand
    >
      {notificationIcon(notification)}
    </box>
  )

  const actions = (
    <box
      class="notification-actions"
    >
      {notification.actions.map(action => {
        function onClicked() {
          notification.invoke(action.id)
          notification.dismiss()
        }
        return (
          <button
            class="notification-actions-button"
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
    notification.dismiss()
    onClose()
  }

  return (
    <box
      class={`notification notification-${notificationUrgency(notification.urgency)}`}
      orientation={Gtk.Orientation.VERTICAL}
    >
      <box>
        <button
          class="notification-expand-button"
          onClicked={toggleExpanded}
          hexpand
        >
          <box>
            {icon}
            <box orientation={Gtk.Orientation.VERTICAL} halign={Gtk.Align.START}>
              {time}
              {title}
              {body}
            </box>
          </box>
        </button>
        <button
          class="notification-close-button"
          onClicked={onDismiss}
          valign={Gtk.Align.START}
        >
          <label label="✕" />
        </button>
      </box>
      {actions}
    </box>
  )
}


export default function Notifications(gdkmonitor: Gdk.Monitor) {
  const notifd = Notifd.get_default()

  const [expandedMap, setExpandedMap] = createState<Map<number, boolean>>(new Map())

  // Use binding instead of manual state management
  const notifications = createBinding(notifd, 'notifications').as(notifs => 
    notifs.sort((a, b) => b.id - a.id)
  )

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
        <scrolledwindow
          vscrollbar_policy={Gtk.PolicyType.AUTOMATIC}
          hscrollbar_policy={Gtk.PolicyType.AUTOMATIC}
        >
          <box orientation={Gtk.Orientation.VERTICAL}>
            <For each={notifications}>
              {(notification) => {
                const notifId = notification.id
                const isExpanded = expandedMap.get().get(notifId) || false
                
                const toggleExpanded = () => {
                  const newMap = new Map(expandedMap.get())
                  newMap.set(notifId, !newMap.get(notifId))
                  setExpandedMap(newMap)
                }
                
                return (
                  <Notification 
                    notification={notification} 
                    isExpanded={isExpanded}
                    toggleExpanded={toggleExpanded}
                    onClose={() => notification.dismiss()}
                  />
                )
              }}
            </For>
          </box>
        </scrolledwindow>
      </box>
    </window>
  )
}
