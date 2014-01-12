import QtQuick 2.0

MouseArea {
    id: queueItemRoot
    width: 280
    height: 50
    drag.target: queueItem

    property int visualIndex: 0
    property alias title: queueText.text
    property string itemType: "queue"

    DropArea {
        anchors.fill: parent
        onEntered: {
            console.log('drag ' + drag.source.itemType);
            if (drag.source.itemType == "queue") {
                var from = drag.source.visualIndex;
                var to = queueItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveQueue(currProject, getStageIndex(), from, to);
                    queueModel2.move(from, to, 1);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: queueItem
        width: 280
        height: 50
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: "#808080"

        Drag.active: queueItemRoot.drag.active
        Drag.source: queueItemRoot
        Drag.hotSpot.x: 140
        Drag.hotSpot.y: 25

        states: [
            State {
                when: queueItem.Drag.active
                ParentChange {
                    target: queueItem
                    parent: root//queueItemRoot.parent
                }

                AnchorChanges {
                    target: queueItem;
                    anchors.horizontalCenter: undefined;
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Text {
            id: queueText
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 22
        }
    }
}
