import { bind } from "astal"

import Hyprland from "gi://AstalHyprland"


export default function BarWorkspaces(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const workspaces = bind(hyprland, 'workspaces').as(wss => {
    const children: JSX.Element[] = []

    for (let i = wss.length - 1; i >= 0; i--) {
      const ws = wss[i]

      const class_name = bind(hyprland, 'focused_workspace').as(focused_ws => {
        const class_names = ["bar-workspace"]
        if (ws.id === focused_ws.id) {
          class_names.push("bar-current-workspace")
        }
        return class_names.join(" ")
      })

      function onClick() {
        hyprland.dispatch("workspace", ws.name)
      }

      children.push(
        <eventbox onClick={onClick}>
          <box className={class_name}>
            <label label={ws.name} />
          </box>
        </eventbox>
      )
    }

    return children
  })

  return (
    <box className="bar-workspaces">
      {workspaces}
    </box>
  )
}
