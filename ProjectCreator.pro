QT += qml quick
TARGET = ProjectCreator
!android: !ios: !blackberry: qtHaveModule(widgets): QT += widgets

OTHER_FILES += \
    main.qml \
    content/TextInputPage.qml \
    content/ProjectPage.qml \
    content/StagePage.qml \
    content/ProjectListPage.qml \
    content/Titlebar.qml \
    content/WarningDialog.qml \
    content/ProjectItem.qml \
    content/StageItem.qml \
    content/QueueItem.qml \
    content/SubqueueItem.qml \
    content/VideoItem.qml \
    content/ScrollContainer.qml \
    content/StageItem2.qml \
    content/QueueItem2.qml \
    content/XButton.qml \
    content/XToolbar.qml \
    content/SubqueuePage.qml \
    content/QueuePage.qml \
    content/SubqueueItem2.qml

RESOURCES += \
    resources.qrc

HEADERS += \
    projectdata.h \

SOURCES += \
    main.cpp \
    projectdata.cpp \

FORMS +=
