// TEST:

import app from "ags/gtk4/app"
import { Astal, Gdk } from "ags/gtk4"

import Clickable from "../../utils/elements/Clickable"


export default function Test(gdkmonitor: Gdk.Monitor) {
  const widget = (
    <box>
      <slider
        class="slider"
        value={0.5} min={0} max={1}
        onChangeValue={({ value }) => print(value)}
      />
      <switch class="switch" active={false} onNotifyActive={({ active }) => print(active)} />
      <Clickable class="Clickable">
        <label label="Hello, World!!!" />
      </Clickable>
    </box>
  )


  return (
    <window
      visible
      name="Test"
      gdkmonitor={gdkmonitor}
      keymode={Astal.Keymode.NONE}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      focusable={true}
      anchor={
        Astal.WindowAnchor.TOP |
        Astal.WindowAnchor.LEFT |
        Astal.WindowAnchor.RIGHT
      }
      application={app}
      layer={Astal.Layer.TOP}
    >
      <box class="test">
        {widget}
      </box>
    </window>
  )
}
