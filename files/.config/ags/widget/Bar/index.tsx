import { App, Astal, Gdk, Gtk } from "astal/gtk3"

import Clock from "./clock"
import Battery from "./battery"
import Network from "./network"
import Bluetooth from "./bluetooth"
import Audio from "./audio"
import Title from "./title"
import Workspaces from "./workspaces"
import Mpris from "./mpris"
import SystemTray from "./system-tray"
import Notifications from "./notifications"


export default function Bar(gdkmonitor: Gdk.Monitor) {
  return (
    <window
      className="Bar"
      name={`Bar-${gdkmonitor}`}
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
      application={App}
    >
      <box className="bar">
        <centerbox>
          <box hexpand halign={Gtk.Align.START} className="bar-left">
            <Workspaces />
          </box>
          <box halign={Gtk.Align.CENTER} className="bar-center">
            <Title />
          </box>
          <box hexpand halign={Gtk.Align.END} className="bar-right">
            <SystemTray />
            <Mpris />
            <Audio />
            <Bluetooth />
            <Network />
            <Battery />
            <Clock show_date={false} show_seconds={true} />
            <Notifications />
          </box>
        </centerbox>
      </box>
    </window>
  )
}
