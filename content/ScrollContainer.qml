import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

ScrollView {
    width: parent.width
    height: parent.height
    //flickableItem.interactive: false

    style: ScrollViewStyle {
        transientScrollBars: false
        handle: Item {
            implicitWidth: 14
            implicitHeight: 26
            Rectangle {
                color: "#424246"
                anchors.fill: parent
//                anchors.topMargin: 6
//                anchors.leftMargin: 4
//                anchors.rightMargin: 4
                anchors.bottomMargin: 10
            }
        }
        scrollBarBackground: Item {
            implicitWidth: 14
            implicitHeight: 26
        }
    }
}
