const notifications = await Service.import('notifications')

notifications.popupTimeout = 5000
notifications.forceTimeout = false
notifications.cacheActions = false
notifications.clearDelay = 100

function notificationIcon({ app_name, app_entry, app_icon, image }) {
  let child;

  if (image) {
    child = Widget.Box({
      css: `
        background-image: url("${image}");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      `,
    })
  } else {
    let icon = 'dialog-information-symbolic'
    if (Utils.lookUpIcon(app_icon)) {
      icon = app_icon
    }
    if (app_entry && Utils.lookUpIcon(app_entry)) {
      icon = app_entry
    }
    child = Widget.Icon(icon)
  }

  return child
}

function notificationPopup(notification) {

  const title = Widget.Label({
    class_name: "notification-popup-title",
    tooltipText: notification.summary,
    xalign: 0,
    justification: 'left',
    hexpand: true,
    max_width_chars: 30,
    truncate: 'end',
    use_markup: true,
    label: notification.summary,
  })

  const body = Widget.Label({
    class_name: "notification-popup-body",
    xalign: 0,
    justification: 'left',
    hexpand: true,
    max_width_chars: 30,
    truncate: 'end',
    use_markup: true,
    label: notification.body,
  })

  return Widget.EventBox({
      attribute: {
        id: notification.id
      },
      on_primary_click: notification.dismiss,
      on_secondary_click: self => {
        if (body.truncate === 'end') {
          body.truncate = 'none'
        } else {
          body.truncate = 'end'
        }
      },
    },
    Widget.Box({
      class_names: [
          "notification-popup",
          `notification-popup-${notification.urgency}`,
      ],
      vertical: true,
      children: [
        Widget.Box([
          Widget.Box({
            class_name: "notification-popup-icon",
            tooltipText: notification.app_name,
            vpack: 'start',
            child: notificationIcon(notification),
          }),
          Widget.Box({
            vertical: true,
            children: [
              title,
              body,
            ]
          }),
        ]),
        Widget.Box({
          class_name: "notification-popup-actions",
          children: notification.actions.map(({ id, label }) => Widget.Button({
            class_name: "notification-popup-action-button",
            on_clicked: () => {
              notification.invoke(id)
              notification.dismiss()
            },
            hexpand: true,
            child: Widget.Label(label),
          })),
        }),
      ]
    })
  )
}


const NotificationPopups = monitor => Widget.Window({
  class_name: "notifications-popups-window",
  monitor,
  name: `notifications-popups-${monitor}`,
  anchor: ['top', 'right'],
  exclusivity: 'ignore',
  layer: 'top',
  margins: [0, 0, 0, 0],
  keymode: 'none',
  child: Widget.Box({
    class_name: "notification-popups",
    vertical: true,
    children: notifications.popups.map(notificationPopup),
    setup: self => {

      self.hook(notifications, (self, id) => {
        const notification = notifications.getNotification(id)
        if (notification) {
          self.children = [notificationPopup(notification), ...self.children]
        }
      }, 'notified')

      self.hook(notifications, (self, id) => {
        self.children.find(notification => notification.attribute.id === id)?.destroy()
      }, 'dismissed')

    }
  })
})

export default NotificationPopups
