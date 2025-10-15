import { Gdk, Gtk } from "ags/gtk4"
import { CCProps } from "ags"

type ClickableOnClickedProps = (
  source: JSX.Element,
  button: number,
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
  onAllClicked?: ClickableOnClickedProps
}

export default function Clickable(
  {
    onClicked,
    onPrimaryClicked,
    onSecondaryClicked,
    onMiddleClicked,
    onAllClicked,
    ...args
  }: ClickableProps
): JSX.Element {
  const setup = (self: Gtk.Box) => {
    const createClick = (button: number, onClicked: ClickableOnClickedProps) => {
      const gesture_click = new Gtk.GestureClick()
      gesture_click.set_button(button)
      self.add_controller(gesture_click)
      gesture_click.connect("pressed", (g, n, x, y) => {
        onClicked(self, button, g, n, x, y)
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
    if (onAllClicked) {
      createClick(Gdk.BUTTON_PRIMARY, onAllClicked)
      createClick(Gdk.BUTTON_SECONDARY, onAllClicked)
      createClick(Gdk.BUTTON_MIDDLE, onAllClicked)
    }

  }

  return (<box $={setup} {...args} />)
}
