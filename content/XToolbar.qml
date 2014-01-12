import QtQuick 2.0

Rectangle {
    id: toolbarRoot
    width: 600
    height: 60
    color: "#030303"

    BorderImage {
        id: borderImage1
        anchors.fill: parent
        border.bottom: 8
        source: "../images/toolbar.png"
    }
    Row {
        id: row1
        spacing: 8
        anchors.fill: parent
        anchors.margins: 5

        XButton {
            id: xButton1
            width: 45
            height: 45
            anchors.verticalCenter: parent.verticalCenter
            icon: "../images/edit_add.png"
        }

        XButton {
            id: xButton2
            width: 45
            height: 45
            anchors.verticalCenter: parent.verticalCenter
            icon: "../images/delete.png"
        }

        XButton {
            id: xButton3
            width: 45
            height: 45
            anchors.verticalCenter: parent.verticalCenter
            icon: "../images/save.png"
        }

        XButton {
            id: xButton4
            width: 45
            height: 45
            anchors.verticalCenter: parent.verticalCenter
            icon: "../images/navigation_previous_item.png"
        }

        Rectangle {
            id: rectangle2
            width: 2
            height: 30
            color: "#cccccc"
            border.color: "#808080"
            border.width: 1
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: text1
            width: 100
            height: 45
            color: "#ffffff"
            text: qsTr("Text")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 28
        }
    }
}
