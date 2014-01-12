import QtQuick 2.1
import QtQml.Models 2.1
import "."

MouseArea {
    id: projectItemRoot
    width: 300
    height: parent.height
    drag.target: projectItem

    property alias title: projectText.text
    property int visualIndex: 0
    property string itemType: "project"

    function getProjectIndex() {
        return projectItemRoot.visualIndex;
    }

    function renameItem(str) {
        ProjectData.renameProject(projectItemRoot.visualIndex, str);
        title = str;
    }

    function moveItem(p, from, to) {
        if (p == projectItemRoot.visualIndex)
            stageModel2.move(from, to, 1);
    }

    function init() {
        var count = ProjectData.getStageCount(projectItemRoot.visualIndex);
        for (var i = 0; i < count; ++i) {
            var str = ProjectData.getStageName(projectItemRoot.visualIndex, i);
            stageModel2.append({name: str});
        }
        root.moveStage.connect(moveItem);
    }

    onPressed: {
        currProject = projectItemRoot.visualIndex;
        console.log('select project ' + projectItemRoot.visualIndex);
    }

    onDoubleClicked: {
        if (isInside(mouseX, mouseY, projectText)) {
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
            if (drag.source.itemType == "project") {
                var from = drag.source.visualIndex;
                var to = projectItemRoot.visualIndex;
                if (from != to) {
                    ProjectData.moveProject(from, to);
                    projectModel.move(from, to, 1);
                    console.log('drag from ' + from + ' to ' + to);
                }
            }
        }
    }

    Rectangle {
        id: projectItem
        width: 300
        height: parent.height
        anchors {
            horizontalCenter: parent.horizontalCenter;
            verticalCenter: parent.verticalCenter
        }
        color: "#4c4c4c"
        border.width: 1
        border.color: currProject==projectItemRoot.visualIndex ? "#cc0000" : "#808080"

        Drag.active: projectItemRoot.drag.active
        Drag.source: projectItemRoot
        Drag.hotSpot.x: 150
        Drag.hotSpot.y: 30

        states: [
            State {
                when: projectItem.Drag.active
                ParentChange {
                    target: projectItem
                    parent: root//projectItemRoot.parent
                }

                AnchorChanges {
                    target: projectItem;
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
                id: projectText
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
                        currProject = projectItemRoot.visualIndex;
                        projectName = title;
                        console.log('edit project ' + currProject);
                        stackView.push( projectPage );
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
                    id: stageVisualModel2
                    model: ListModel {
                        id: stageModel2
                    }
                    delegate: StageItem2 {
                        title: name
                        visualIndex: DelegateModel.itemsIndex
                    }
                }
                Component.onCompleted: projectItemRoot.init()
            }
        }
    }
}
