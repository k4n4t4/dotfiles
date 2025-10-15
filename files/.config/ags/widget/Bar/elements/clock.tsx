import { Gdk, Gtk } from "ags/gtk4"
import { createState } from "ags"
import { Clickable, createDateTime } from "../../../utils"


const date_time = createDateTime(1000)

export default function BarClock(params: {
  show_date?: boolean
  show_seconds?: boolean
}): JSX.Element {
  const [show_seconds, set_show_seconds] = createState(params.show_seconds || false)
  const [show_date, set_show_date] = createState(params.show_date || false)

  return (
    <Clickable onAllClicked={(_, button) => {
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
    }} class="bar-clock">

      <revealer
        transitionDuration={500}
        transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
        revealChild={show_date} >
        <label label={date_time(t => t.format("%m-%d-%Y (%a) ")!)} />
      </revealer>

      <label label={date_time(t => t.format("%H:%M")!)} />

      <revealer
        transitionDuration={500}
        transitionType={Gtk.RevealerTransitionType.SLIDE_RIGHT}
        revealChild={show_seconds} >
        <label label={date_time(t => t.format(":%S")!)} />
      </revealer>

    </Clickable>
  )
}
