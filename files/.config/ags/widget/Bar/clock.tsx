import { Astal, Gtk } from "astal/gtk3"
import { Variable, bind } from "astal"


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
  show_date?: boolean
  show_seconds?: boolean
}


export default function BarClock(params: clock_params): JSX.Element {

  const CLOCK = Variable({}).poll(1000, () => {
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

  const show_seconds = Variable(params.show_seconds)
  const show_date = Variable(params.show_date)

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
      revealChild={bind(show_seconds)} >
      <label label={seconds} />
    </revealer>
  )

  const revealer_left = (
    <revealer
      transitionDuration={500}
      transitionType={Gtk.RevealerTransitionType.SLIDE_LEFT}
      revealChild={bind(show_date)} >
      <label label={date} />
    </revealer>
  )

  const label = (<label label={time} />)


  function onClick(_self: Astal.EventBox, event: Astal.ClickEvent) {
    switch (event.button) {
      case Astal.MouseButton.PRIMARY:
        show_seconds.set(!show_seconds.get())
        break
      case Astal.MouseButton.SECONDARY:
        show_date.set(!show_date.get())
        break
    }
  }


  return (
    <eventbox onClick={onClick}>
      <box className="bar-clock">
        {revealer_left}
        {label}
        {revealer_right}
      </box>
    </eventbox>
  )
}
