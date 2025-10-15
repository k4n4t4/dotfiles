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
      namespace="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      application={app}
      layer={Astal.Layer.BOTTOM}
    >
      <centerbox hexpand orientation={Gtk.Orientation.HORIZONTAL}>
        <box $type="start">
          <Workspaces />
          <Submap />
        </box>
        <box $type="center">
          <Title />
        </box>
        <box $type="end">
          <SystemTray show_items={[
            "Input Method",
          ]} reveal={false} />
          <Mpris />
          <Audio />
          <Bluetooth />
          <Network />
          <Battery />
          <Clock />
          <Notifications />
        </box>
      </centerbox>
    </window>
  )
}
