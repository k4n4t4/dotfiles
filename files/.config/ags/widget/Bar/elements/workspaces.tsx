import { createBinding } from "ags"

import Hyprland from "gi://AstalHyprland"


export default function BarWorkspaces(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const workspaces = createBinding(hyprland, 'workspaces').as(wss => {
    const children: any[] = []

    for (let i = wss.length - 1; i >= 0; i--) {
      const ws = wss[i]

      const class_name = createBinding(hyprland, 'focused_workspace').as(focused_ws => {
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
        <box data-id={ws.id}>
          <eventbox onClick={onClick}>
            <box class={class_name}>
              <label label={ws.name} />
            </box>
          </eventbox>
        </box>
      )
    }

    children.sort((a, b) => {
      return a["data-id"] - b["data-id"]
    })

    return children
  })

  return (
    <box class="bar-workspaces">
      {workspaces}
    </box>
  )
}
