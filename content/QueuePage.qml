import QtQuick 2.1
import QtQml.Models 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "."

ScrollContainer {
    id: queueView

    function addItem(str) {
        subqueueModel.append({name: str});
        console.log(str + ' was created');
    }

    function removeItem(i) {
        subqueueModel.remove(i);
        if (currSubqueue >= subqueueModel.count)
            currSubqueue = subqueueModel.count - 1;
    }

    function init() {
        subqueueModel.clear();
        var count = ProjectData.getSubqueueCount(currProject, currStage, currQueue);
        for (var i= 0; i < count; ++i) {
            var str = ProjectData.getSubqueueName(currProject, currStage, currQueue, i);
            addItem(str);
        }
        root.newSubqueue.connect(addItem);
        root.removeSubqueue.connect(removeItem);
    }

    ListView {
        orientation: ListView.Horizontal
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
        model: DelegateModel {
            id: subqueueVisualModel
            model: ListModel {
                id: subqueueModel
            }
            delegate: SubqueueItem {
                title: name
                visualIndex: DelegateModel.itemsIndex
            }
        }

        Component.onCompleted: queueView.init()
    }
}
