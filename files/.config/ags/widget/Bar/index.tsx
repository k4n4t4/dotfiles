import { App, Astal, Gdk, Gtk } from "astal/gtk3"

import Clock from "./elements/clock"
import Battery from "./elements/battery"
import Network from "./elements/network"
import Bluetooth from "./elements/bluetooth"
import Audio from "./elements/audio"
import Title from "./elements/title"
import Workspaces from "./elements/workspaces"
import Submap from "./elements/submap"
import Mpris from "./elements/mpris"
import SystemTray from "./elements/system-tray"
import Notifications from "./elements/notifications"


export default function Bar(gdkmonitor: Gdk.Monitor) {
  return (
    <window
      name="Bar"
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
      layer={Astal.Layer.BOTTOM}
    >
      <box className="bar">
        <centerbox>
          <box hexpand halign={Gtk.Align.START} className="bar-left">
            <Workspaces />
            <Submap />
          </box>
          <box halign={Gtk.Align.CENTER} className="bar-center">
            <Title />
          </box>
          <box hexpand halign={Gtk.Align.END} className="bar-right">
            <SystemTray show_items={[
              "Input Method",
            ]} reveal={false} />
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
