import QtQuick 2.0
import QtQml.Models 2.1
import "."

MouseArea {
    id: subqueueItemRoot
    width: 300
    height: parent.height
    drag {
        target: subqueueItem
//        axis: Drag.YAxis
    }

    property int visualIndex: 0 // subqueue index
    property alias title: subqueueText.text
    property string itemType: "subqueue"

    function getSubqueueIndex() {
        return subqueueItemRoot.visualIndex;
    }

    function renameItem(str) {
        ProjectData.renameSubqueue(currProject, currStage, currQueue, subqueueItemRoot.visualIndex, str);
        title = str;
    }

    function init() {
        var count = ProjectData.getVideoCount(currProject, currStage, currQueue, subqueueItemRoot.visualIndex);
        for (var i = 0; i < count; ++i) {
            var str = ProjectData.getVideoName(currProject, currStage, currQueue, subqueueItemRoot.visualIndex, i);
            videoModel.append({name: str});
        }
    }

    onPressed: {
        currSubqueue = subqueueItemRoot.visualIndex;
        console.log('select subqueue ' + subqueueItemRoot.visualIndex);
    }

    onDoubleClicked: {
        if (isInside(mouseX, mouseY, subqueueText)) {
            var obj = loadComponent("qrc:///content/TextInputPage.qml", root);
            obj.text = title;
            obj.accepted.connect(subqueueItemRoot.renameItem);// 实现两个qml组件之间的通信
        }
    }

    DropArea {
        width: parent.width
        height: 35
        onEntered: {
            var source = drag.source;
            console.log('drag ' + source.itemType);
            if (source.itemType == "subqueue" && source.queueIndex == subqueueItemRoot.queueIndex) {
                var from = source.visualIndex;
                var to = subqueueItemRoot.visualIndex;
                if (from != to) {
                    //ProjectData.moveSubqueue(currProject, currStage, currQueue, from, to);
                    subqueueModel.move(from, to, 1);
                    root.moveSubqueue(currQueue, from, to);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: subqueueItem
        width: 300
        height: parent.height
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: currSubqueue==subqueueItemRoot.visualIndex ? "#cc0000" : "#808080"

        Drag.active: subqueueItemRoot.drag.active
        Drag.source: subqueueItemRoot
        Drag.hotSpot.x: 150
        Drag.hotSpot.y: 30

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

        Rectangle {
            id: titleBar
            width: parent.width - 2
            height: 60
            x: 1
            y: 1
            color: "#333333"

            Rectangle {
                x: 1
                y: 1
                width: parent.width - 2
                height: 60
                color: "#333333"

                Text {
                    id: subqueueText
                    x: 10
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    font.pixelSize: 28
                }
            }
        }

        ScrollContainer {
            anchors {
                fill: parent
                leftMargin: 8
                rightMargin: 8
                bottomMargin: 8
                topMargin: 70
            }
            ListView {
                id: listView
                anchors.fill: parent
                interactive: false
                displaced: Transition {
                    NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
                }
                model: DelegateModel {
                    id: videoVisualModel
                    model: ListModel {
                        id: videoModel
                    }
                    delegate: VideoItem {
                        visualIndex: DelegateModel.itemsIndex
                        title: name
                    }
                }
                Component.onCompleted: subqueueItemRoot.init()
            }
        }
    }
}
