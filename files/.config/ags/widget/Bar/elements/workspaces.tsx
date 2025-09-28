import { createBinding, For } from "ags"
import Hyprland from "gi://AstalHyprland"


export default function BarWorkspaces(): JSX.Element {
  const hyprland = Hyprland.get_default()

  const workspaces = createBinding(hyprland, 'workspaces').as(wss => wss.map(ws => {
      const class_name = createBinding(hyprland, 'focused_workspace').as(focused_ws => {
        const class_names = ["bar-workspace"]
        if (ws.id === focused_ws.id) {
          class_names.push("bar-current-workspace")
        }
        return class_names.join(" ")
      })

      return {
        id: ws.id,
        element: (
          <box class={`ws_${ws.id}`}>
            <button onClicked={() => {hyprland.dispatch("workspace", ws.name)}}>
              <box class={class_name}>
                <label label={ws.name} />
              </box>
            </button>
          </box>
        )
      }
    }).sort((a, b) => a.id - b.id)
  )

  return (
    <box class="bar-workspaces">
      <For each={workspaces}>
        {workspace => workspace.element}
      </For>
    </box>
  )
}
