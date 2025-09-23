import { Gtk } from "ags/gtk4"
import { createState } from "ags"
import { createPoll } from "ags/time"

type clock = {
  month?: string,
  date?: string,
  year?: string,
  hours?: string,
  minutes?: string,
  seconds?: string,
  day?: string,
}

type clock_params = {
  show_date: boolean
  show_seconds: boolean
}


export default function BarClock(params: clock_params): JSX.Element {

  const CLOCK = createPoll<clock>({}, 1000, () => {
    const date = new Date()
    const days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
    return {
      get month()   { return ("00"   + (date.getMonth()+1)).slice(-2) },
      get date()    { return ("00"   + date.getDate()     ).slice(-2) },
      get year()    { return ("0000" + date.getFullYear() ).slice(-4) },
      get hours()   { return ("00"   + date.getHours()    ).slice(-2) },
      get minutes() { return ("00"   + date.getMinutes()  ).slice(-2) },
      get seconds() { return ("00"   + date.getSeconds()  ).slice(-2) },
      get day()     { return days[date.getDay()] }
    }
  })

  const [show_seconds, set_show_seconds] = createState(params.show_seconds)
  const [show_date, set_show_date] = createState(params.show_date)

  const seconds = CLOCK((clock: clock): string => {
    return `:${clock.seconds}`
  })
  const date = CLOCK((clock: clock): string => {
    return `${clock.month}-${clock.date}-${clock.year} (${clock.day}) `
  })
  const time = CLOCK((clock: clock): string => {
    return `${clock.hours}:${clock.minutes}`
  })

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


  function onClicked() {
    set_show_seconds(!show_seconds.get())
    set_show_date(!show_date.get())
  }


  return (
    <button onClicked={onClicked}>
      <box class="bar-clock">
        {revealer_left}
        {label}
        {revealer_right}
      </box>
    </button>
  )
}
