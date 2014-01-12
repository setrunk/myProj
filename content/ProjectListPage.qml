import QtQuick 2.1
import QtQml.Models 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import "."

ScrollContainer {
    id: projectListView

    function addItem(str) {
        projectModel.append({name: str});
        console.log(str + ' was created');
    }

    function removeItem(i) {
        projectModel.remove(i);
        if (currProject >= projectModel.count)
            currProject = projectModel.count - 1;
    }

    function init() {
        var count = ProjectData.getProjectCount();
        for (var i= 0; i < count; ++i) {
            var str = ProjectData.getProjectName(i);
            addItem(str);
        }
        root.newProject.connect(addItem);
        root.removeProject.connect(removeItem);
    }

    ListView {
        orientation: ListView.Horizontal
        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
        Component {
            id: projectPage
            ProjectPage {}
        }
        model: DelegateModel {
            id: projectVisualModel
            model: ListModel {
                id: projectModel
            }
            delegate: ProjectItem {
                title: name
                visualIndex: DelegateModel.itemsIndex
            }
        }

        Component.onCompleted: projectListView.init()
    }
}
