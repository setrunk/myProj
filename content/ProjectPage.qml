import QtQuick 2.1
import QtQml.Models 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "."

ScrollContainer {
    id: projectView

    function addItem(str) {
        stageModel.append({name: str});
        console.log(str + ' was created');
    }

    function removeItem(i) {
        stageModel.remove(i);
        if (currStage >= stageModel.count)
            currStage = stageModel.count - 1;
    }

    function init() {
        var count = ProjectData.getStageCount(currProject);
        for (var i= 0; i < count; ++i) {
            var str = ProjectData.getStageName(currProject, i);
            addItem(str);
        }
        root.newStage.connect(addItem);
        root.removeStage.connect(removeItem);
    }

    ListView {
        orientation: ListView.Horizontal
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
        Component {
            id: stagePage
            StagePage {}
        }
        model: DelegateModel {
            id: stageVisualModel
            model: ListModel {
                id: stageModel
            }
            delegate: StageItem {
                title: name
                visualIndex: DelegateModel.itemsIndex
            }
        }

        Component.onCompleted: projectView.init()
    }
}
