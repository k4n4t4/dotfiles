import GObject, { register } from "ags/gobject"
import { monitorFile, readFileAsync } from "ags/file"
import { exec, execAsync } from "ags/process"

const get = (args: string) => Number(exec(`brightnessctl ${args}`))
const screenDevice = exec(`bash -c "ls -w1 /sys/class/backlight | head -1"`).trim()
const kbdDevice = exec(`bash -c "ls -w1 /sys/class/leds | head -1"`).trim()

@register({ GTypeName: "Brightness" })
export default class Brightness extends GObject.Object {
    static instance: Brightness
    static get_default() {
        if (!this.instance)
            this.instance = new Brightness()

        return this.instance
    }

    #kbdMax = get(`--device ${kbdDevice} max`)
    #kbd = get(`--device ${kbdDevice} get`)
    #screenMax = get("max")
    #screen = get("get") / (get("max") || 1)

    #screenCallbacks = new Set<() => void>()

    watchScreen(cb: () => void) {
        this.#screenCallbacks.add(cb)
        return () => this.#screenCallbacks.delete(cb)
    }

    #emitScreen() {
        this.#screenCallbacks.forEach(cb => cb())
    }

    get kbd() { return this.#kbd }

    set kbd(value) {
        if (value < 0 || value > this.#kbdMax)
            return

        execAsync(`brightnessctl -d ${kbdDevice} s ${value} -q`).then(() => {
            this.#kbd = value
            this.notify("kbd")
        })
    }

    get screen() { return this.#screen }

    set screen(percent) {
        if (percent < 0)
            percent = 0

        if (percent > 1)
            percent = 1

        this.#screen = percent
        this.#emitScreen()
        execAsync(`brightnessctl set ${Math.floor(percent * 100)}% -q`)
    }

    constructor() {
        super()

        const screenPath = `/sys/class/backlight/${screenDevice}/brightness`
        const kbdPath = `/sys/class/leds/${kbdDevice}/brightness`

        monitorFile(screenPath, async f => {
            const v = await readFileAsync(f)
            this.#screen = Number(v) / this.#screenMax
            this.#emitScreen()
        })

        monitorFile(kbdPath, async f => {
            const v = await readFileAsync(f)
            this.#kbd = Number(v) / this.#kbdMax
            this.notify("kbd")
        })
    }
}
