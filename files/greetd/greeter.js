const greetd = await Service.import('greetd');

const username = Widget.Box({
  class_name: "greeter-username",
  hpack: 'center',
  child: Widget.Entry({
    placeholder_text: "USERNAME",
    onAccept: () => {
      password.child.grab_focus()
    },
  })
})

const password = Widget.Box({
  class_name: "greeter-password",
  hpack: 'center',
  child: Widget.Entry({
    placeholder_text: "PASSWORD",
    visibility: false,
    onAccept: () => {
      greetd.login(
        username.child.text || "",
        password.child.text || "",
        "/etc/greetd/login.sh"
      ).catch(err => {
        response.child.label = JSON.stringify(err)
      })
    },
  })
})

const response = Widget.Box({
  class_name: "greeter-responce",
  hpack: 'center',
  child: Widget.Label({
    label: "",
    justification: 'left',
    max_width_chars: 50,
    truncate: 'end',
  }),
})

const greeter = Widget.Window({
  class_name: "greeter-window",
  name: "greeter",
  anchor: ['top', 'left', 'right', 'bottom'],
  exclusivity: 'normal',
  layer: 'overlay',
  keymode: 'exclusive',
  child: Widget.Box({
    class_name: "greeter",
    vertical: true,
    hpack: 'center',
    vpack: 'center',
    hexpand: true,
    vexpand: true,
    children: [
      Widget.Box({
        class_name: "greeter-title",
        hpack: 'center',
        child: Widget.Label("Hello, World!")
      }),
      username,
      password,
      response,
    ],
  }),
})

App.config({
  style: "/etc/greetd/greeter.css",
  windows: [
    greeter
  ]
})
