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
    class_name: "notifications-popup-title",
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
    class_name: "notifications-popup-body",
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
          "notifications-popup",
          `notifications-popup-${notification.urgency}`,
      ],
      vertical: true,
      children: [
        Widget.Box([
          Widget.Box({
            class_name: "notifications-popup-icon",
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
          class_name: "notifications-popup-actions",
          children: notification.actions.map(({ id, label }) => Widget.Button({
            class_name: "notifications-popup-action-button",
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

function notificationNotification(notification) {

  const title = Widget.Label({
    class_name: "notifications-notification-title",
    tooltipText: notification.summary,
    xalign: 0,
    justification: 'left',
    hexpand: true,
    use_markup: true,
    max_width_chars: 30,
    truncate: 'end',
    label: notification.summary,
  })

  const body = Widget.Label({
    class_name: "notifications-notification-body",
    xalign: 0,
    justification: 'left',
    hexpand: true,
    use_markup: true,
    max_width_chars: 30,
    truncate: 'end',
    label: notification.body,
  })

  return Widget.EventBox({
      attribute: {
        id: notification.id
      },
      on_primary_click: notification.close,
    },
    Widget.Box({
      class_names: [
          "notifications-notification",
          `notifications-notification-${notification.urgency}`,
      ],
      vertical: true,
      children: [
        Widget.Box([
          Widget.Box({
            class_name: "notifications-notification-icon",
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
          class_name: "notifications-notification-actions",
          children: notification.actions.map(({ id, label }) => Widget.Button({
            class_name: "notifications-notification-action-button",
            on_clicked: () => {
              notification.invoke(id)
              notification.close()
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
    class_name: "notifications-popups",
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

const NotificationNotifications = monitor => Widget.Window({
  class_name: "notifications-notifications-window",
  monitor,
  visible: false,
  name: `notifications-notifications-${monitor}`,
  anchor: ['top', 'right'],
  exclusivity: 'ignore',
  layer: 'top',
  margins: [0, 0, 0, 0],
  keymode: 'none',
  child: Widget.Box({
    class_names: notifications.bind("notifications").as(notifications => {
      const class_names = ["notifications-notifications"]
      if (notifications.length > 0) {
        class_names.push("notifications-notifications-exist")
      }
      return class_names
    }),
    vertical: true,
    children: notifications.notifications.map(notificationNotification),
    setup: self => {

      self.hook(notifications, (self, id) => {
        const notification = notifications.getNotification(id)
        if (notification) {
          self.children = [notificationNotification(notification), ...self.children]
        }
      }, 'notified')

      self.hook(notifications, (self, id) => {
        self.children.find(notification => notification.attribute.id === id)?.destroy()
      }, 'closed')

    }
  }),
})

export default { NotificationPopups, NotificationNotifications }
