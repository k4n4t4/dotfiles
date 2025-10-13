// TEST:

import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import { CCProps } from "ags"

// TODO :

type ClickableOnClickedProps = (
  source: JSX.Element,
  gesture_click: Gtk.GestureClick,
  n_press: number,
  x: number,
  y: number
) => void

type ClickableProps = Partial<CCProps<Gtk.Box, Gtk.Box.ConstructorProps>> & {
  onClicked?: ClickableOnClickedProps
  onPrimaryClicked?: ClickableOnClickedProps
  onSecondaryClicked?: ClickableOnClickedProps
  onMiddleClicked?: ClickableOnClickedProps
}

function Clickable(
  {
    onClicked,
    onPrimaryClicked,
    onSecondaryClicked,
    onMiddleClicked,
    ...args
  }: ClickableProps
): JSX.Element {
  const setup = (self: Gtk.Box) => {
    const createClick = (button: number, onClicked: ClickableOnClickedProps) => {
      const gesture_click = new Gtk.GestureClick()
      gesture_click.set_button(button)
      self.add_controller(gesture_click)
      gesture_click.connect("pressed", (g, n, x, y) => {
        onClicked(self, g, n, x, y)
      })
    }

    if (onClicked) {
      createClick(0, onClicked)
    }
    if (onPrimaryClicked) {
      createClick(Gdk.BUTTON_PRIMARY, onPrimaryClicked)
    }
    if (onSecondaryClicked) {
      createClick(Gdk.BUTTON_SECONDARY, onSecondaryClicked)
    }
    if (onMiddleClicked) {
      createClick(Gdk.BUTTON_MIDDLE, onMiddleClicked)
    }
  }

  return (<box $={setup} {...args} />)
}

export default function Test(gdkmonitor: Gdk.Monitor) {
  const widget = (
    <Clickable>
      <label label="Hello, World!!!" />
      <Clickable />
    </Clickable>
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
