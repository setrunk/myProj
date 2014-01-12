import QtQuick 2.0

Rectangle {
    id: buttonRoot
    width: 60
    height: 60
    color: "#020202"
    border.color: "#b3b3b3"
    border.width: 0

    signal clicked
    property alias icon: image1.source

    Image {
        id: image1
        anchors.fill: parent
        anchors.margins: 2
        source: ""
    }

    MouseArea {
        id: mouseArea1
        hoverEnabled: true
        anchors.fill: parent
        onEntered: buttonRoot.border.width = 1
        onExited: buttonRoot.border.width = 0
        onPressed: buttonRoot.color = "#808080"
        onReleased: buttonRoot.color = "#020202"
        onClicked: buttonRoot.clicked()
    }
}
