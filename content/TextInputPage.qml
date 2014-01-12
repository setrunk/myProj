import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

MouseArea {
    id: textInputRoot
    width: 350
    height: 150
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter

    property alias text: textField.text

    signal accepted(string str)

    Component.onCompleted: {
        textField.selectAll();
        textField.focus = true;
    }

    Rectangle {
        height: 120
        color: "#333333"
        border.color: "#808080"
        border.width: 2
        anchors.fill: parent

        Component {
            id: touchStyle

            TextFieldStyle {
                textColor: "white"
                font.pixelSize: 28
                background: Item {
                    implicitHeight: 50
                    implicitWidth: 320
                    BorderImage {
                        source: "../images/textinput.png"
                        border.left: 8
                        border.right: 8
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                    }
                }
            }
        }

        TextField {
            id: textField
            x: 10
            y: 10
            width: 330
            height: 50
            anchors.margins: 20
            text: "name"
            style: touchStyle

            onAccepted: {
                textInputRoot.accepted(text);
                textInputRoot.destroy();
            }
        }

        Item {
            x: 88
            y: 80
            width: 58
            height: 58

            Rectangle {
                radius: 4
                anchors.fill: parent
                antialiasing: true
                color: "#222"
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
                        textInputRoot.accepted(text);
                        textInputRoot.destroy();
                    }
                }
            }
        }

        Item {
            x: 223
            y: 80
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
                    onClicked: textInputRoot.destroy()
                }
            }
        }
    }
}
