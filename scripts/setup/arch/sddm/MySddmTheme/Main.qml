import QtQuick 2.15
import QtQuick.Effects
import SddmComponents 2.0

Rectangle {
    id: root

    width: Screen.width
    height: Screen.height
    color: theme.background

    Image {
        id: backdrop
        anchors.fill: parent
        source: "assets/background.png"
        fillMode: Image.PreserveAspectCrop
    }

    QtObject {
        id: theme
        readonly property color background: "#111111"
        readonly property color accent: "#d0bb00"
        readonly property color accentHover: "#e0cb10"
        readonly property color accentPressed: "#b8a300"
        readonly property color field: "#333333"
        readonly property color dropdown: "#222222"
        readonly property color border: "#444444"
        readonly property color hover: "#555555"
        readonly property color text: "#ffffff"
        readonly property color textDim: "#bbbbbb"
        readonly property color placeholder: "#888888"
        readonly property color icon: "#777777"
        readonly property color iconHover: "#bbbbbb"
        readonly property color error: "#ff5555"
        readonly property color panel: "#80000000"
        readonly property int fieldWidth: 300
        readonly property int fieldHeight: 40
        readonly property int fontSize: 14
        readonly property int inputFontSize: 18
        readonly property int dropdownRadius: 16
        readonly property int barHeight: 56
        readonly property int panelRadius: 24
        readonly property int panelPadding: 30
    }

    component BlurPanel: Item {
        id: panel
        property Item source
        property real radius: 0
        property bool bordered: true

        ShaderEffectSource {
            id: snap
            anchors.fill: parent
            sourceItem: panel.source
            sourceRect: {
                var p = panel.mapToItem(panel.source, 0, 0)
                return Qt.rect(p.x, p.y, panel.width, panel.height)
            }
            visible: false
        }

        Rectangle {
            id: mask
            anchors.fill: parent
            radius: panel.radius
            layer.enabled: true
            visible: false
        }

        MultiEffect {
            anchors.fill: parent
            source: snap
            blurEnabled: true
            blur: 1.0
            blurMax: 64
            maskEnabled: true
            maskSource: mask
        }

        Rectangle {
            anchors.fill: parent
            radius: panel.radius
            color: theme.panel
            border.width: panel.bordered ? 1 : 0
            border.color: theme.border
        }
    }

    component EyeIcon: Canvas {
        property color color: theme.icon
        property bool slashed: false

        width: 22
        height: 16

        onColorChanged: requestPaint()
        onSlashedChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = color
            ctx.fillStyle = color
            ctx.lineWidth = 1.6
            ctx.lineCap = "round"

            ctx.beginPath()
            ctx.moveTo(1, height / 2)
            ctx.quadraticCurveTo(width / 2, -height / 2, width - 1, height / 2)
            ctx.quadraticCurveTo(width / 2, height * 1.5, 1, height / 2)
            ctx.stroke()

            ctx.beginPath()
            ctx.arc(width / 2, height / 2, 3, 0, Math.PI * 2)
            ctx.fill()

            if (slashed) {
                ctx.beginPath()
                ctx.moveTo(4, height - 1)
                ctx.lineTo(width - 4, 1)
                ctx.stroke()
            }
        }
    }

    component InputBox: FocusScope {
        id: box
        property alias text: input.text
        property string placeholder: ""
        property int echoMode: TextInput.Normal
        property int rightPadding: 18
        signal submit()

        width: theme.fieldWidth
        height: theme.fieldHeight

        Rectangle {
            anchors.fill: parent
            radius: height / 2
            color: theme.field
            border.width: 1
            border.color: input.activeFocus ? theme.accent : theme.border
        }

        TextInput {
            id: input
            anchors {
                left: parent.left; leftMargin: 18
                right: parent.right; rightMargin: box.rightPadding
                verticalCenter: parent.verticalCenter
            }
            focus: true
            clip: true
            color: theme.text
            font.pixelSize: theme.inputFontSize
            selectionColor: theme.accent
            selectedTextColor: theme.background
            echoMode: box.echoMode
            Keys.onReturnPressed: box.submit()
            Keys.onEnterPressed: box.submit()
        }

        Text {
            anchors.fill: input
            verticalAlignment: Text.AlignVCenter
            visible: input.text === ""
            text: box.placeholder
            color: theme.placeholder
            font.pixelSize: theme.inputFontSize
            elide: Text.ElideRight
        }
    }

    component Field: InputBox {}

    component Secret: InputBox {
        id: secret
        property bool revealed: false

        echoMode: revealed ? TextInput.Normal : TextInput.Password
        rightPadding: keyboard.capsLock ? 96 : 50

        Text {
            anchors { right: toggle.left; rightMargin: 10; verticalCenter: parent.verticalCenter }
            visible: keyboard.capsLock
            text: "CAPS"
            color: theme.accent
            font.pixelSize: 11
            font.bold: true
        }

        EyeIcon {
            id: toggle
            anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
            slashed: secret.revealed
            color: toggleMouse.containsMouse ? theme.iconHover : theme.icon

            MouseArea {
                id: toggleMouse
                anchors.fill: parent
                anchors.margins: -6
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    secret.revealed = !secret.revealed
                    secret.forceActiveFocus()
                }
            }
        }
    }

    component Label: Text {
        anchors.horizontalCenter: parent.horizontalCenter
        color: theme.text
        font.pixelSize: theme.fontSize
    }

    component Selector: Rectangle {
        id: sel

        property var model
        property string textRole: ""
        property int currentIndex: 0
        property string currentText: ""
        property alias open: dropdown.visible
        signal picked(int index)

        function toggle() {
            open = !open
            if (open)
                view.currentIndex = currentIndex
        }

        width: theme.fieldWidth
        height: theme.fieldHeight
        radius: height / 2
        color: theme.field
        border.width: 1
        border.color: selMouse.containsMouse ? theme.hover : theme.border
        z: open ? 300 : 100

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                sel.toggle()
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                sel.open = false
                event.accepted = true
            }
        }

        Text {
            anchors {
                left: parent.left; leftMargin: 18
                right: arrow.left; rightMargin: 4
                verticalCenter: parent.verticalCenter
            }
            text: sel.currentText
            color: theme.text
            font.pixelSize: theme.fontSize
            elide: Text.ElideRight
        }

        Text {
            id: arrow
            anchors { right: parent.right; verticalCenter: parent.verticalCenter }
            width: parent.height
            horizontalAlignment: Text.AlignHCenter
            text: "▼"
            color: theme.text
            font.pixelSize: 10
        }

        MouseArea {
            id: selMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: sel.toggle()
        }

        Rectangle {
            id: dropdown

            anchors { left: parent.left; top: parent.bottom; topMargin: 4 }
            width: parent.width
            height: Math.min(view.count * theme.fieldHeight, 240)
            radius: theme.dropdownRadius
            color: theme.dropdown
            border.width: 1
            border.color: theme.border
            visible: false
            clip: true

            ListView {
                id: view
                anchors.fill: parent
                anchors.margins: 1
                model: sel.model
                clip: true
                currentIndex: sel.currentIndex

                delegate: Item {
                    id: item
                    width: view.width
                    height: theme.fieldHeight

                    readonly property string label: sel.textRole === "" ? modelData.longName : model[sel.textRole]
                    readonly property bool first: index === 0
                    readonly property bool last: index === view.count - 1
                    readonly property int innerRadius: theme.dropdownRadius - 1

                    Component.onCompleted: {
                        if (index === sel.currentIndex)
                            sel.currentText = label
                    }

                    Rectangle {
                        anchors.fill: parent
                        visible: itemMouse.containsMouse
                        color: theme.border
                        topLeftRadius: item.first ? item.innerRadius : 0
                        topRightRadius: item.first ? item.innerRadius : 0
                        bottomLeftRadius: item.last ? item.innerRadius : 0
                        bottomRightRadius: item.last ? item.innerRadius : 0
                    }

                    Text {
                        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
                        anchors.leftMargin: 17
                        anchors.rightMargin: 17
                        text: item.label
                        color: theme.text
                        font.pixelSize: theme.fontSize
                        elide: Text.ElideRight
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            sel.currentIndex = index
                            sel.currentText = item.label
                            sel.open = false
                            sel.picked(index)
                        }
                    }
                }
            }
        }
    }

    TextConstants { id: textConstants }

    function login() {
        sddm.login(username.text, password.text, sessionSelector.currentIndex)
    }

    function closeDropdowns() {
        sessionSelector.open = false
        keyboardSelector.open = false
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            password.text = ""
            message.text = textConstants.loginFailed
        }

        function onInformationMessage(messageText) {
            message.text = messageText
        }
    }

    BlurPanel {
        id: topBar
        source: backdrop
        bordered: false
        anchors { left: parent.left; right: parent.right; top: parent.top }
        height: theme.barHeight
    }

    MouseArea {
        anchors.fill: parent
        z: 250
        enabled: sessionSelector.open || keyboardSelector.open
        propagateComposedEvents: true
        onPressed: function(mouse) {
            root.closeDropdowns()
            mouse.accepted = false
        }
    }

    Selector {
        id: sessionSelector
        anchors { left: parent.left; leftMargin: 20; verticalCenter: topBar.verticalCenter }
        model: sessionModel
        textRole: "name"
        currentIndex: sessionModel.lastIndex

        KeyNavigation.backtab: password
        KeyNavigation.tab: keyboardSelector
    }

    Selector {
        id: keyboardSelector
        anchors { left: sessionSelector.right; leftMargin: 10; verticalCenter: topBar.verticalCenter }
        width: 220
        model: keyboard.layouts
        currentIndex: keyboard.currentLayout
        onPicked: function(index) { keyboard.currentLayout = index }

        KeyNavigation.backtab: sessionSelector
        KeyNavigation.tab: loginButton
    }

    Item {
        id: clock

        property date now: new Date()

        anchors { right: parent.right; rightMargin: 20; verticalCenter: topBar.verticalCenter }
        width: Math.max(timeText.width, dateText.width)
        height: timeText.height + dateText.height

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clock.now = new Date()
        }

        Text {
            id: timeText
            anchors.right: parent.right
            text: Qt.formatTime(clock.now, "hh:mm")
            color: theme.text
            font.pixelSize: 22
            font.bold: true
        }

        Text {
            id: dateText
            anchors { right: parent.right; top: timeText.bottom }
            text: Qt.locale().toString(clock.now, "yyyy/MM/dd (ddd)")
            color: theme.textDim
            font.pixelSize: 12
        }
    }

    BlurPanel {
        id: loginPanel
        source: backdrop
        anchors.horizontalCenter: parent.horizontalCenter
        y: form.y - theme.panelPadding
        width: form.width + theme.panelPadding * 2
        height: form.height + theme.panelPadding * 2
        radius: theme.panelRadius
    }

    Column {
        id: form
        anchors.horizontalCenter: parent.horizontalCenter
        y: (root.height - height) / 2
        width: theme.fieldWidth
        spacing: 10

        Label {
            text: "Login"
            color: theme.accent
            font.pixelSize: 32
            bottomPadding: 12
        }

        Field {
            id: username
            anchors.horizontalCenter: parent.horizontalCenter
            placeholder: "Username"
            text: userModel.lastUser
            KeyNavigation.tab: password
            onSubmit: root.login()
        }

        Secret {
            id: password
            anchors.horizontalCenter: parent.horizontalCenter
            placeholder: "Password"
            KeyNavigation.backtab: username
            KeyNavigation.tab: sessionSelector
            onSubmit: root.login()
        }

        Item { width: 1; height: 10 }

        Rectangle {
            id: loginButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: theme.fieldWidth
            height: theme.fieldHeight
            radius: height / 2

            color: loginMouse.pressed ? theme.accentPressed
                 : loginMouse.containsMouse ? theme.accentHover
                 : theme.accent

            KeyNavigation.backtab: keyboardSelector

            Keys.onPressed: function(event) {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter || event.key === Qt.Key_Space) {
                    root.login()
                    event.accepted = true
                }
            }

            Text {
                anchors.centerIn: parent
                text: textConstants.login
                color: theme.background
                font.pixelSize: theme.fontSize
                font.bold: true
            }

            MouseArea {
                id: loginMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: root.login()
            }
        }

        Text {
            id: message
            anchors.horizontalCenter: parent.horizontalCenter
            width: theme.fieldWidth
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: theme.error
            font.pixelSize: theme.fontSize
        }
    }

    Component.onCompleted: (username.text === "" ? username : password).forceActiveFocus()
}
