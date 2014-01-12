import QtQuick 2.0

MouseArea {
    id: subqueueItemRoot
    width: 280
    height: 50
    drag.target: subqueueItem

    property int visualIndex: 0
    property alias title: subqueueText.text
    property string itemType: "subqueue"

    DropArea {
        anchors.fill: parent
        onEntered: {
            console.log('drag ' + drag.source.itemType);
            if (drag.source.itemType == "subqueue") {
                var from = drag.source.visualIndex;
                var to = subqueueItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveSubqueue(currProject, currStage, getQueueIndex(), from, to);
                    subqueueModel2.move(from, to, 1);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: subqueueItem
        width: 280
        height: 50
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: "#808080"

        Drag.active: subqueueItemRoot.drag.active
        Drag.source: subqueueItemRoot
        Drag.hotSpot.x: 140
        Drag.hotSpot.y: 25

        states: [
            State {
                when: subqueueItem.Drag.active
                ParentChange {
                    target: subqueueItem
                    parent: root//queueItemRoot.parent
                }

                AnchorChanges {
                    target: subqueueItem;
                    anchors.horizontalCenter: undefined;
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Text {
            id: subqueueText
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 22
        }
    }
}
