import { Gdk, Gtk } from "ags/gtk4"
import { createState } from "ags"
import { createPoll } from "ags/time"
import Clickable from "../../../utils/Clickable"
import GLib from "gi://GLib?version=2.0"

const date_time = createPoll<GLib.DateTime>(GLib.DateTime.new_now_local(), 1000, () => GLib.DateTime.new_now_local())

type clock_params = {
  show_date: boolean
  show_seconds: boolean
}

export default function BarClock(params: clock_params): JSX.Element {
  const [show_seconds, set_show_seconds] = createState(params.show_seconds)
  const [show_date, set_show_date] = createState(params.show_date)

  const seconds = date_time(t => t.format(":%S")!)
  const date = date_time(t => t.format("%m-%d-%Y (%a) ")!)
  const time = date_time(t => t.format("%H:%M")!)


  const revealer_right = (
    <revealer
      transitionDuration={500}
      transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
      revealChild={show_seconds} >
      <label label={seconds} />
    </revealer>
  )

  const revealer_left = (
    <revealer
      transitionDuration={500}
      transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
      revealChild={show_date} >
      <label label={date} />
    </revealer>
  )

  const label = (<label label={time} />)


  function onClicked(_: JSX.Element, button: number) {
    switch (button) {
      case Gdk.BUTTON_PRIMARY:
        set_show_date(!show_date.get())
        break
      case Gdk.BUTTON_SECONDARY:
        set_show_seconds(!show_seconds.get())
        break
      case Gdk.BUTTON_MIDDLE:
        set_show_date(!show_date.get())
        set_show_seconds(!show_seconds.get())
        break
    }
  }


  return (
    <Clickable onAllClicked={onClicked} class="bar-clock">
      {revealer_left}
      {label}
      {revealer_right}
    </Clickable>
  )
}
