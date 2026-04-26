import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: rootItem
    property var gameObj
    property string posterSource: ""
    property bool selected: false
    property real cardRadius: 12
    property color cardBaseColor: "#161616"
    property color fallbackBackgroundColor: "#2a2d32"
    property color placeholderTextColor: "#f0f0f0"
    property color inactiveTextColor: "#d0d0d0"
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property real posterTitlePixelSize: 24
    property real labelPixelSize: 16
    property real posterAspectRatio: 1.5
    property bool mouseEnabled: true
    property bool hovered: mouseArea.containsMouse
    property alias coverVisual: cardWrap
    property alias launchVisual: rootItem

    signal clicked()
    signal launchRequested()

    scale: hovered ? 1.07 : 1.0
    opacity: selected || hovered ? 1.0 : 0.86

    Behavior on scale { NumberAnimation { duration: 120 } }
    Behavior on opacity { NumberAnimation { duration: 120 } }

    Item {
        id: cardWrap
        x: Math.round((parent.width - width) * 0.5)
        y: hovered ? 6 : 8
        width: Math.round(parent.width * 0.90)
        height: Math.round(width * posterAspectRatio)

        DropShadow {
            anchors.fill: gridCard
            source: gridCard
            horizontalOffset: 0
            verticalOffset: hovered ? 3.5 : 3
            radius: 10
            samples: 25
            color: hovered ? "#42000000" : "#28000000"
        }

        Rectangle {
            id: gridCard
            width: parent.width
            height: parent.height
            radius: cardRadius
            color: cardBaseColor
        }

        Image {
            id: gridCoverSource
            anchors.fill: gridCard
            source: posterSource
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            cache: true
            smooth: true
            sourceSize.width: Math.round(gridCard.width * 2)
            sourceSize.height: Math.round(gridCard.height * 2)
            visible: false
        }

        OpacityMask {
            anchors.fill: gridCard
            source: gridCoverSource
            visible: posterSource !== ""
            maskSource: Rectangle {
                width: gridCard.width
                height: gridCard.height
                radius: cardRadius
                color: "white"
            }
        }

        DefaultPoster {
            id: defaultPosterContent
            anchors.fill: gridCard
            visible: false
            backgroundColor: fallbackBackgroundColor
            titleText: gameObj ? gameObj.title : ""
            metaText: ""
            condensedFontFamily: condensedFontFamily
            sansFontFamily: sansFontFamily
            titleColor: placeholderTextColor
            titlePixelSize: posterTitlePixelSize
            metaPixelSize: Math.round(labelPixelSize * 0.9)
        }

        OpacityMask {
            anchors.fill: gridCard
            source: defaultPosterContent
            visible: posterSource === ""
            maskSource: Rectangle {
                width: gridCard.width
                height: gridCard.height
                radius: cardRadius
                color: "white"
            }
        }

        Rectangle {
            anchors.fill: gridCard
            radius: cardRadius
            visible: selected
            color: "transparent"
            border.width: 4
            border.color: "#f0ffffff"
            opacity: hovered ? 0.95 : 0.78
        }

        Rectangle {
            id: playOverlay
            anchors.centerIn: gridCard
            width: Math.round(gridCard.width * 0.28)
            height: width
            radius: width * 0.5
            visible: opacity > 0
            opacity: selected && hovered ? 1.0 : 0.0
            color: "#cc111111"
            border.width: 1
            border.color: "#70ffffff"

            Behavior on opacity { NumberAnimation { duration: 100 } }

            Image {
                anchors.centerIn: parent
                source: "../assets/ui/play.svg"
                width: Math.round(parent.width * 0.42)
                height: width
                fillMode: Image.PreserveAspectFit
                smooth: true
                asynchronous: true
            }
        }
    }

    Item {
        anchors.top: cardWrap.bottom
        anchors.topMargin: 7
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.92
        height: gridLabel.height

        DropShadow {
            anchors.fill: gridLabel
            source: gridLabel
            horizontalOffset: 0
            verticalOffset: 2
            radius: 5
            samples: 11
            color: "#38000000"
        }

        Text {
            id: gridLabel
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            text: gameObj ? gameObj.title : ""
            color: selected ? "white" : inactiveTextColor
            font.family: sansFontFamily
            font.pixelSize: labelPixelSize
            maximumLineCount: 2
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: rootItem.mouseEnabled
        hoverEnabled: rootItem.mouseEnabled
        cursorShape: rootItem.mouseEnabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        acceptedButtons: Qt.LeftButton
        onClicked: {
            if (rootItem.selected)
                rootItem.launchRequested()
            else
                rootItem.clicked()
        }
        onDoubleClicked: {
            if (!rootItem.selected)
                rootItem.clicked()
            rootItem.launchRequested()
        }
        onWheel: wheel.accepted = false
    }
}
