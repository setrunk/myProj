import QtQuick 2.0

MouseArea {
    id: warningDialogRoot
    width: 400
    height: 150
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    signal accepted

    property alias text: alertText.text

    Rectangle {
        anchors.fill: parent
        color: "#333333"
        border.width: 2
        border.color: "#808080"

        Text {
            id: alertText
            x: 10
            y: 20
            width: parent.width - 20
            height: 50
            horizontalAlignment: Text.AlignHCenter
            text: "Hello World"
            color: "white"
            font.pixelSize: 28
        }

        Item {
            x: 111
            y: 85
            width: 58
            height: 58

            Rectangle {
                radius: 4
                anchors.fill: parent
                antialiasing: true
                color: "#212121"
                visible: acceptMouse.pressed
            }

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: "../images/ok.png"

                MouseArea {
                    id: acceptMouse
                    anchors.fill: parent
                    onClicked: {
                        warningDialogRoot.accepted()
                        warningDialogRoot.destroy();
                    }
                }
            }
        }

        Item {
            x: 251
            y: 85
            width: 58
            height: 58

            Rectangle {
                radius: 4
                anchors.fill: parent
                antialiasing: true
                color: "#222"
                visible: cancelMouse.pressed
            }

            Image {
                anchors.fill: parent
                anchors.margins: 5
                source: "../images/stop.png"

                MouseArea {
                    id: cancelMouse
                    anchors.fill: parent
                    onClicked: warningDialogRoot.destroy()
                }
            }
        }
    }
}

