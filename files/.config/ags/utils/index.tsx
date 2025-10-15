import { execAsync } from "ags/process"
import { createPoll } from "ags/time"
import GLib from "gi://GLib?version=2.0"

export * from "./elements"

export function createDateTime(interval: number = 1000) {
  return createPoll<GLib.DateTime>(GLib.DateTime.new_now_local(), interval, () => GLib.DateTime.new_now_local())
}

export function runNmtui() {
  execAsync(`
    st -f 'ComicShannsMono Nerd Font Mono-14' -i env NEWT_COLORS='
    root=white,black
    roottext=yellow,black

    border=gray,black
    window=gray,black
    shadow=,
    title=white,black

    button=black,green
    actbutton=white,green
    compactbutton=black,cyan

    checkbox=black,yellow
    actcheckbox=green,yellow

    entry=black,lightgray
    disentry=white,black

    label=lightgray,black

    listbox=white,gray
    actlistbox=lightgray,black
    sellistbox=white,gray
    actsellistbox=black,green

    textbox=black,gray
    acttextbox=black,cyan

    emptyscale=,gray
    fullscale=,cyan

    helpline=yellow,cyan
    ' nmtui
  `)
}
