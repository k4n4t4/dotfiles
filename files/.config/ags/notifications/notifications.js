const notifications = await Service.import('notifications')

notifications.popupTimeout = 5000
notifications.forceTimeout = false
notifications.cacheActions = false
notifications.clearDelay = 100


function notificationIcon({ app_entry, app_icon, image }) {
  if (image) {
    return Widget.Box({
      css: `
        background-image: url("${image}");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      `,
    })
  }

  let icon = 'dialog-information-symbolic'
  if (Utils.lookUpIcon(app_icon)) {
    icon = app_icon
  }
  if (app_entry && Utils.lookUpIcon(app_entry)) {
    icon = app_entry
  }

  return Widget.Icon(icon)
}

function NotificationPopup(notification) {
  return Widget.EventBox({
      attribute: { id: notification.id },
      on_primary_click: notification.dismiss,
    },
    Widget.Box({
        class_name: `notification-popup notification-${notification.urgency}`,
        vertical: true,
      },
      Widget.Box([
        Widget.Box({
          class_name: "notification-icon",
          vpack: 'start',
          child: notificationIcon(notification),
        }),
        Widget.Box(
          { vertical: true },
          Widget.Label({
            class_name: "notification-title",
            xalign: 0,
            justification: 'left',
            hexpand: true,
            max_width_chars: 24,
            truncate: 'end',
            wrap: true,
            use_markup: true,
            label: notification.summary,
          }),
          Widget.Label({
            class_name: "notification-body",
            xalign: 0,
            justification: 'left',
            hexpand: true,
            wrap: true,
            use_markup: true,
            label: notification.body,
          }),
        ),
      ]),
      Widget.Box({
        class_name: "notification-actions",
        children: notification.actions.map(({ id, label }) => Widget.Button({
          class_name: "notification-action-button",
          on_clicked: () => {
            notification.invoke(id)
            notification.dismiss()
          },
          hexpand: true,
          child: Widget.Label(label),
        })),
      }),
    )
  )
}


const NotificationPopups = monitor => Widget.Window({
  class_name: "notifications",
  monitor,
  name: `notifications-${monitor}`,
  anchor: ['top', 'right'],
  exclusivity: 'ignore',
  layer: 'top',
  margins: [30, 0, 0, 0],
  keymode: 'none',
  child: Widget.Box({
    class_name: "notification-popups",
    vertical: true,
    child: Widget.Box({
      vertical: true,
      children: notifications.popups.map(NotificationPopup),
      setup: self => {
        self.hook(notifications, (self, id) => {
          const notification = notifications.getNotification(id)
          if (notification) {
            self.children = [NotificationPopup(notification), ...self.children]
          }
        }, 'notified')
        self.hook(notifications, (self, id) => {
          self.children.find(notification => notification.attribute.id === id)?.destroy()
        }, 'dismissed')
      }
    })
  }),
})

export default NotificationPopups
