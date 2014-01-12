/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.1
import QtQuick.Controls 1.1
import "content"

Item {
    id: root
    width: 1024
    height: 768

    //-------------------------------------------
    // property
    property int toolbarHeight: 60
    property int toolbarButtonSize: 40
    property int toolbarButtonSpacing: 10
    property string projectName: ""
    property string stageName: ""
    property string queueName: ""
    property string subqueueName: ""
    property int currProject: -1
    property int currStage: -1
    property int currQueue: -1
    property int currSubqueue: -1

    //-------------------------------------------
    // signal
    signal newProject(string str)
    signal newStage(string str)
    signal newQueue(string str)
    signal newSubqueue(string str)
    signal removeProject(int i)
    signal removeStage(int i)
    signal removeQueue(int i)
    signal removeSubqueue(int i)
    signal moveStage(int p, int from, int to)
    signal moveQueue(int s, int from, int to)
    signal moveSubqueue(int q, int from, int to)

    //-------------------------------------------
    // function

    function updateTitle() {
        switch (stackView.depth) {
        case 1:
            toolbar.text = "Player list";
            break;
        case 2:
            toolbar.text = projectName;
            break;
        case 3:
            toolbar.text = projectName+"/"+stageName;
            break;
        case 4:
            toolbar.text = projectName+"/"+stageName+"/"+queueName;
            break;
        case 5:
            toolbar.text = projectName+"/"+stageName+"/"+queueName+"/"+subqueueName;
            break;
        }
        toolbar.enableBackbutton(stackView.depth > 1);
    }

    function loadComponent(url, p) {
        var bQml;
        var component = Qt.createComponent(url);
        if (component.status == Component.Ready) {
            bQml = component.createObject(p);
        }
        return bQml;
    }

    function isInside(mx, my, item) {
        var ptx = mx - item.x;
        var pty = my - item.y;
        if (ptx > 0 && ptx < item.width && pty > 0 && pty < item.height)
            return true;
        return false;
    }

    function onAddItem(str) {
        switch (stackView.depth) {
        case 1:
            ProjectData.newProject(str);
            root.newProject(str);
            break;
        case 2:
            ProjectData.newStage(currProject, str);
            root.newStage(str);
            break;
        case 3:
            ProjectData.newQueue(currProject, currStage, str);
            root.newQueue(str);
            break;
        case 4:
            ProjectData.newSubqueue(currProject, currStage, currQueue, str);
            root.newSubqueue(str);
            break;
        }
    }

    function onRemoveItem() {
        switch (stackView.depth) {
        case 1:
            ProjectData.removeProject(currProject);
            root.removeProject(currProject);
            break;
        case 2:
            ProjectData.removeStage(currProject, currStage);
            root.removeStage(currStage);
            break;
        case 3:
            ProjectData.removeQueue(currProject, currStage, currQueue);
            root.removeQueue(currQueue);
            break;
        case 4:
            ProjectData.removeSubqueue(currProject, currStage, currQueue, currSubqueue);
            root.removeSubqueue(currSubqueue);
            break;
        }
    }

    //-------------------------------------------
    // children

    Rectangle {
        id: background
        color: "#212126"
        anchors.fill: parent
    }

    Titlebar {
        id: toolbar
        onClickSave: {
            ProjectData.save();
        }
        onClickBack: {
            if (stackView.depth > 1) {
                stackView.pop();
                updateTitle();
            }
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        anchors.topMargin: toolbarHeight+2
        initialItem: ProjectListPage { id: projectListPage }
    }

//    XToolbar {
//        width: root.width
//    }
}
