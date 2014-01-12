import QtQuick 2.0

MouseArea {
    id: stageItemRoot
    width: 280
    height: 50
    drag.target: stageItem

    property int visualIndex: 0
    property alias title: stageText.text
    property string itemType: "stage"

    DropArea {
        anchors.fill: parent
        onEntered: {
            console.log('drag ' + drag.source.itemType);
            if (drag.source.itemType == "stage") {
                var from = drag.source.visualIndex;
                var to = stageItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveStage(getProjectIndex(), from, to);
                    stageModel2.move(from, to, 1);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: stageItem
        width: 280
        height: 50
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: "#808080"

        Drag.active: stageItemRoot.drag.active
        Drag.source: stageItemRoot
        Drag.hotSpot.x: 140
        Drag.hotSpot.y: 25

        states: [
            State {
                when: stageItem.Drag.active
                ParentChange {
                    target: stageItem
                    parent: root//stageItemRoot.parent
                }

                AnchorChanges {
                    target: stageItem;
                    anchors.horizontalCenter: undefined;
                    anchors.verticalCenter: undefined
                }
            }
        ]

        Text {
            id: stageText
            x: 10
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 22
        }
    }
}
