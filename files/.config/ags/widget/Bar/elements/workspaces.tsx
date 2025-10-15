import { createBinding, For } from "ags"
import Hyprland from "gi://AstalHyprland"


export default function() {
  const hyprland = Hyprland.get_default()

  const workspaces = createBinding(hyprland, 'workspaces').as(wss => wss.map(ws => {
    const class_names = createBinding(hyprland, 'focused_workspace').as(focused_ws => {
      const class_names = ["workspace", `ws_${ws.id}`]
      if (ws.id === focused_ws.id) {
        class_names.push("current-workspace")
      }
      return class_names
    })

    return {
      id: ws.id,
      element: (
        <button cssClasses={class_names} onClicked={() => {hyprland.dispatch("workspace", ws.name)}}>
          <label label={ws.name} />
        </button>
      )
    }
  }).sort((a, b) => a.id - b.id))

  return (
    <box class="workspaces">
      <For each={workspaces}>
        {workspace => workspace.element}
      </For>
    </box>
  )
}
