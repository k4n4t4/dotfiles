import { createPoll } from "ags/time"
import GLib from "gi://GLib?version=2.0"

export {default as Clickable} from "./Clickable"

export function createDateTime(interval: number = 1000) {
  return createPoll<GLib.DateTime>(GLib.DateTime.new_now_local(), interval, () => GLib.DateTime.new_now_local())
}
