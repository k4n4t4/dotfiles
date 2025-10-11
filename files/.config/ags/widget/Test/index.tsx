// TEST:

import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"

// TODO :
function Clickable({onClicked = 1, ...args}) {
  return (
    <box {...args} $={self => {
      const g = new Gtk.GestureClick()
      const g0 = new Gtk.GestureClick()
      const g1 = new Gtk.GestureClick()
      const g2 = new Gtk.GestureClick()
      g.set_button(0)
      g0.set_button(Gdk.BUTTON_PRIMARY)
      g1.set_button(Gdk.BUTTON_SECONDARY)
      g2.set_button(Gdk.BUTTON_MIDDLE)
      self.add_controller(g)
      self.add_controller(g0)
      self.add_controller(g1)
      self.add_controller(g2)
      g.connect("pressed", (g, n, x, y) => {
        onClicked(self, g, n, x, y)
      })
      g0.connect("pressed", () => { print(0) })
      g1.connect("pressed", () => { print(1) })
      g2.connect("pressed", () => { print(2) })
    }}>
    </box>
  )
}

export default function Test(gdkmonitor: Gdk.Monitor) {
  const widget = (
    <box $={self => {
      const g0 = new Gtk.GestureClick()
      const g1 = new Gtk.GestureClick()
      const g2 = new Gtk.GestureClick()
      g0.set_button(Gdk.BUTTON_PRIMARY)
      g1.set_button(Gdk.BUTTON_SECONDARY)
      g2.set_button(Gdk.BUTTON_MIDDLE)
      self.add_controller(g0)
      self.add_controller(g1)
      self.add_controller(g2)
      g0.connect("pressed", () => { print(0) })
      g1.connect("pressed", () => { print(1) })
      g2.connect("pressed", () => { print(2) })
    }}>
      <label label="Hello, World!!!" />
    </box>
  )


  return (
    <window
      visible
      name="Test"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      margin-top={1}
      margin-left={1}
      margin-right={1}
      application={app}
      layer={Astal.Layer.BOTTOM}
    >
      <box class="test">
        {widget}
      </box>
    </window>
  )
}
