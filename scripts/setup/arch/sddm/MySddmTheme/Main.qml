import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#111111"

    property int sessionIndex: session.index

    TextConstants {
        id: textConstants
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

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 350

        text: "Login"
        color: "#d0bb00"
        font.pixelSize: 32
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 405

        text: "Username"
        color: "#ffffff"
        font.pixelSize: 14
    }

    TextBox {
        id: username

        anchors.horizontalCenter: parent.horizontalCenter
        y: 430

        width: 300
        height: 40

        color: "#333333"
        textColor: "#ffffff"

        text: userModel.lastUser

        KeyNavigation.tab: password

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return ||
                event.key === Qt.Key_Enter) {
                sddm.login(
                    username.text,
                    password.text,
                    sessionIndex
                )
                event.accepted = true
            }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 485

        text: "Password"
        color: "#ffffff"
        font.pixelSize: 14
    }

    PasswordBox {
        id: password

        anchors.horizontalCenter: parent.horizontalCenter
        y: 510

        width: 300
        height: 40

        color: "#333333"
        textColor: "#ffffff"

        KeyNavigation.backtab: username
        KeyNavigation.tab: session

        Keys.onPressed: function(event) {
            if (event.key === Qt.Key_Return ||
                event.key === Qt.Key_Enter) {
                sddm.login(
                    username.text,
                    password.text,
                    sessionIndex
                )
                event.accepted = true
            }
        }
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        y: 560

        text: "Session"
        color: "#ffffff"
        font.pixelSize: 14
    }

    ComboBox {
        id: session

        anchors.horizontalCenter: parent.horizontalCenter
        y: 585

        width: 300
        height: 40

        z: 10

        color: "#333333"
        menuColor: "#222222"
        textColor: "#ffffff"
        borderColor: "#444444"
        focusColor: "#555555"
        hoverColor: "#444444"

        model: sessionModel
        index: sessionModel.lastIndex

        KeyNavigation.backtab: password
        KeyNavigation.tab: loginButton
    }

    Rectangle {
        anchors.right: session.right
        anchors.top: session.top

        width: 22
        height: session.height

        color: "#3f3f3f"

        z: 11
        enabled: false

        Text {
            anchors.centerIn: parent

            text: "▼"
            color: "#ffffff"
            font.pixelSize: 10
        }
    }

    Button {
        id: loginButton

        anchors.horizontalCenter: parent.horizontalCenter
        y: 640

        width: 300
        height: 40

        text: textConstants.login

        onClicked: {
            sddm.login(
                username.text,
                password.text,
                session.index
            )
        }

        KeyNavigation.backtab: session
    }

    Text {
        id: message

        anchors.horizontalCenter: parent.horizontalCenter
        y: 700

        width: 400

        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        color: "#ff5555"
        font.pixelSize: 14
    }

    Component.onCompleted: {
        if (username.text === "") {
            username.focus = true
        } else {
            password.focus = true
        }
    }
}
