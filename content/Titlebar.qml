import QtQuick 2.0

BorderImage {
    id: titleBarRoot
    border.bottom: 8
    source: "qrc:///images/toolbar.png"
    width: parent.width
    height: toolbarHeight

    property alias text: toolbar_title.text

    //signal clickAdd
    //signal clickRemove
    signal clickSave
    signal clickBack

    function clickAdd() {
        var obj = loadComponent("qrc:///content/TextInputPage.qml", root);
        obj.accepted.connect(root.onAddItem);// 实现两个qml组件之间的通信
    }

    function clickRemove() {
        var obj = loadComponent("qrc:///content/WarningDialog.qml", root);
        obj.text = "Delete selected item?";
        obj.accepted.connect(root.onRemoveItem);
    }

    function enableBackbutton(b) {
        if (b) {
            backButton.enabled = true;
            backimage.opacity = 1
        }
        else {
            backButton.enabled = false;
            backimage.opacity = 0.3
        }
    }

    Component.onCompleted: {
        enableBackbutton(false);
    }

    Item {
        id: addButton
        width: toolbarButtonSize
        height: toolbarButtonSize
        x: toolbarButtonSpacing
        anchors.verticalCenter: parent.verticalCenter

        signal clicked

        Rectangle {
            radius: 4
            anchors.fill: parent
            antialiasing: true
            color: "#222"
            visible: addmouse.pressed
        }

        Image {
            id: addimage
            anchors.fill: parent
            anchors.margins: 5
            source: "qrc:///images/edit_add.png"
            MouseArea {
                id: addmouse
                anchors.fill: parent
                onClicked: titleBarRoot.clickAdd()//titleBarRoot.clickAdd()
            }
        }
    }

    Item {
        id: removeButton
        width: toolbarButtonSize
        height: toolbarButtonSize
        x: addButton.x + addButton.width + toolbarButtonSpacing
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            radius: 4
            anchors.fill: parent
            antialiasing: true
            color: "#222"
            visible: removemouse.pressed
        }

        Image {
            id: removeimage
            anchors.fill: parent
            anchors.margins: 5
            source: "qrc:///images/delete.png"
            MouseArea {
                id: removemouse
                anchors.fill: parent
                onClicked: titleBarRoot.clickRemove()
            }
        }
    }

    Item {
        id: saveButton
        width: toolbarButtonSize
        height: toolbarButtonSize
        x: removeButton.x + removeButton.width + toolbarButtonSpacing
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            radius: 4
            anchors.fill: parent
            antialiasing: true
            color: "#222"
            visible: savemouse.pressed
        }

        Image {
            id: saveimage
            anchors.fill: parent
            anchors.margins: 5
            source: "qrc:///images/save.png"
            MouseArea {
                id: savemouse
                anchors.fill: parent
                onClicked: titleBarRoot.clickSave()
            }
        }
    }

    Item {
        id: backButton
        width: toolbarButtonSize
        height: toolbarButtonSize
        x: saveButton.x + saveButton.width + toolbarButtonSpacing
        anchors.verticalCenter: parent.verticalCenter

        Rectangle {
            radius: 4
            anchors.fill: parent
            antialiasing: true
            color: "#222"
            visible: backmouse.pressed
        }

        Image {
            id: backimage
            anchors.fill: parent
            anchors.margins: 5
            Behavior on opacity { NumberAnimation {} }
            source: "qrc:///images/navigation_previous_item.png"
            MouseArea {
                id: backmouse
                anchors.fill: parent
                onClicked: titleBarRoot.clickBack()
            }
        }
    }

    Text {
        id: toolbar_title
        font.pixelSize: 30
        x: backButton.x + backButton.width + 20
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        text: "Player list"
    }
}
