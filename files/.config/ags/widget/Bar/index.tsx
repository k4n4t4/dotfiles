import app from "ags/gtk4/app"
import { Astal, Gdk, Gtk } from "ags/gtk4"

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
      visible
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
      application={app}
      layer={Astal.Layer.BOTTOM}
    >
      <box class="bar">
        aaa
        <centerbox orientation={Gtk.Orientation.HORIZONTAL}>
          <box hexpand $type="start" class="bar-left">
            <Workspaces />
            {/* <Submap /> */}
          </box>
          <box $type="center" class="bar-center">
            {/* <Title /> */}
          </box>
          <box hexpand $type="end" class="bar-right">
            {/* <SystemTray show_items={[ */}
            {/*   "Input Method", */}
            {/* ]} reveal={false} /> */}
            {/* <Mpris /> */}
            {/* <Audio /> */}
            {/* <Bluetooth /> */}
            {/* <Network /> */}
            {/* <Battery /> */}
            {/* <Clock show_date={false} show_seconds={true} /> */}
            {/* <Notifications /> */}
          </box>
        </centerbox>
      </box>
    </window>
  )
}
