import QtQuick 2.1
import QtQml.Models 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "."

ScrollContainer {
    id: stageView

    function addItem(str) {
        queueModel.append({name: str});
        console.log(str + ' was created');
    }

    function removeItem(i) {
        queueModel.remove(i);
        if (currQueue >= queueModel.count)
            currQueue = queueModel.count - 1;
    }

    function init() {
        queueModel.clear();
        var count = ProjectData.getQueueCount(currProject, currStage);
        for (var i= 0; i < count; ++i) {
            var str = ProjectData.getQueueName(currProject, currStage, i);
            addItem(str);
        }
        root.newQueue.connect(addItem);
        root.removeQueue.connect(removeItem);
    }

    ListView {
        orientation: ListView.Horizontal
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
        Component {
            id: queuePage
            QueuePage {}
        }
        model: DelegateModel {
            id: queueVisualModel
            model: ListModel {
                id: queueModel
            }
            delegate: QueueItem {
                title: name
                visualIndex: DelegateModel.itemsIndex
            }
        }

        Component.onCompleted: stageView.init()
    }
}
