import QtQuick 2.1
import QtQml.Models 2.1
import "."

MouseArea {
    id: stageItemRoot
    width: 300
    height: parent.height
    drag.target: stageItem

    property alias title: stageText.text
    property int visualIndex: 0
    property string itemType: "stage"

    function getStageIndex() {
        return stageItemRoot.visualIndex;
    }

    function rename(str) {
        ProjectData.renameStage(currProject, visualIndex, str);
        title = str;
    }

    function moveItem(s, from, to) {
        if (s == stageItemRoot.visualIndex)
            queueModel2.move(from, to, 1);
    }

    function init() {
        var count = ProjectData.getQueueCount(currProject, stageItemRoot.visualIndex);
        for (var i = 0; i < count; ++i) {
            var str = ProjectData.getQueueName(currProject, stageItemRoot.visualIndex, i);
            queueModel2.append({name: str});
        }
        root.moveQueue.connect(moveItem);
    }

    onPressed: {
        currStage = stageItemRoot.visualIndex;
        console.log('select stage ' + stageItemRoot.visualIndex);
    }

    onDoubleClicked: {
        if (isInside(mouseX, mouseY, stageText)) {
            var obj = loadComponent("qrc:///content/TextInputPage.qml", root);
            obj.text = title;
            obj.accepted.connect(rename);// 实现两个qml组件之间的通信
        }
    }

    DropArea {
        width: parent.width
        height: 60
        onEntered: {
            console.log('drag ' + drag.source.itemType);
            if (drag.source.itemType == "stage") {
                var from = drag.source.visualIndex;
                var to = stageItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveStage(currProject, from, to);
                    stageModel.move(from, to, 1);
                    root.moveStage(currProject, from, to);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: stageItem
        width: 300
        height: parent.height
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: currStage==stageItemRoot.visualIndex ? "#cc0000" : "#808080"

        Drag.active: stageItemRoot.drag.active
        Drag.source: stageItemRoot
        Drag.hotSpot.x: 150
        Drag.hotSpot.y: 30

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

        Rectangle {
            x: 1
            y: 1
            width: parent.width - 2
            height: 60
            color: "#333333"

            Text {
                id: stageText
                x: 10
                anchors.verticalCenter: parent.verticalCenter
                color: "white"
                font.pixelSize: 28
            }

            Image {
                width: 32
                height: 32
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 8
                source: "../images/navigation_next_item.png"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        currStage = stageItemRoot.visualIndex;
                        stageName = title;
                        stackView.push(stagePage);
                        updateTitle();
                    }
                }
            }
        }

        ScrollContainer {
            anchors {
                fill: parent
                leftMargin: 10
                topMargin: 70
                rightMargin: 10
                bottomMargin: 10
            }
            ListView {
                anchors.fill: parent
                interactive: false
                displaced: Transition {
                    NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
                }
                model: DelegateModel {
                    id: queueVisualModel
                    model: ListModel {
                        id: queueModel2
                    }
                    delegate: QueueItem2 {
                        visualIndex: DelegateModel.itemsIndex
                        title: name
                    }
                }
                Component.onCompleted: stageItemRoot.init()
            }
        }
    }
}
