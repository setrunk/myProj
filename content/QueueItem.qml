import QtQuick 2.0
import QtQml.Models 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "."

MouseArea {
    id: queueItemRoot
    width: 300
    height: parent.height
    drag.target: queueItem

    property int visualIndex: 0 // queue index
    property alias title: queueText.text
    property string itemType: "queue"

    function getQueueIndex() {
        return queueItemRoot.visualIndex;
    }

    function renameItem(str) {
        ProjectData.renameQueue(currProject, currStage, queueItemRoot.visualIndex, str);
        title = str;
    }

    function moveItem(s, from, to) {
        if (s == queueItemRoot.visualIndex)
            subqueueModel2.move(from, to, 1);
    }

    function init() {
        var count = ProjectData.getSubqueueCount(currProject, currStage, queueItemRoot.visualIndex);
        for (var i = 0; i < count; ++i) {
            var str = ProjectData.getSubqueueName(currProject, currStage, queueItemRoot.visualIndex, i);
            subqueueModel2.append({name: str});
        }
        root.moveSubqueue.connect(moveItem);
    }

    onPressed: {
        currQueue = queueItemRoot.visualIndex;
        console.log('select queue ' + queueItemRoot.visualIndex);
    }

    onDoubleClicked: {
        if (isInside(mouseX, mouseY, queueText)) {
            var obj = loadComponent("qrc:///content/TextInputPage.qml", root);
            obj.text = title;
            obj.accepted.connect(renameItem);// 实现两个qml组件之间的通信
        }
    }

    DropArea {
        width: parent.width
        height: 60
        onEntered: {
            console.log('drag ' + drag.source.itemType);
            if (drag.source.itemType == "queue") {
                var from = drag.source.visualIndex;
                var to = queueItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveQueue(currProject, currStage, from, to);
                    queueModel.move(from, to, 1);
                    root.moveQueue(currStage, from, to);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: queueItem
        width: 300
        height: parent.height
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: currQueue==queueItemRoot.visualIndex ? "#cc0000" : "#808080"

        Drag.active: queueItemRoot.drag.active
        Drag.source: queueItemRoot
        Drag.hotSpot.x: 150
        Drag.hotSpot.y: 30

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
                    id: queueText
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
                            currQueue = queueItemRoot.visualIndex;
                            queueName = title;
                            stackView.push(queuePage);
                            updateTitle();
                        }
                    }
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
                    id: subqueueVisualModel
                    model: ListModel {
                        id: subqueueModel2
                    }
                    delegate: SubqueueItem2 {
                        visualIndex: DelegateModel.itemsIndex
                        title: name
                    }
                }
                Component.onCompleted: queueItemRoot.init()
            }
        }
    }
}
