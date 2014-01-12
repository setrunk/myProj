import QtQuick 2.0

MouseArea {
    id: videoItemRoot
    width: 280
    height: 50
    drag.target: videoItem

    property int visualIndex: 0
    property alias title: videoText.text
    property string itemType: "video"

    DropArea {
        anchors.fill: parent
        onEntered: {
            console.log('drag ' + drag.source.itemType);
            if (drag.source.itemType == "video") {
                var from = drag.source.visualIndex;
                var to = videoItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveVideo(getSubqueueIndex(), from, to);
                    videoModel.move(from, to, 1);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: videoItem
        width: 280
        height: 50
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: "#808080"

        Drag.active: videoItemRoot.drag.active
        Drag.source: videoItemRoot
        Drag.hotSpot.x: 140
        Drag.hotSpot.y: 25

        states: [
            State {
                when: videoItem.Drag.active
                ParentChange {
                    target: videoItem
                    parent: root//stageItemRoot.parent
                }

                AnchorChanges {
                    target: videoItem;
                    anchors.horizontalCenter: undefined;
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Text {
            id: videoText
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 22
        }
    }
}
