import QtQuick 2.15
import QtGraphicalEffects 1.15

Item {
    id: root

    property color textColor: "#92ffffff"
    property color hoverTextColor: "white"
    property color hoverBackgroundColor: "#18ffffff"
    property color hoverBorderColor: "#30ffffff"
    property string fontFamily: ""
    property real textPixelSize: 16
    property string prefixText: ""
    property string labelText: "Sorted by:"
    property string valueText: ""
    property string iconSource: ""
    property real iconScale: 1.0
    property bool mouseEnabled: true
    readonly property bool prefixHovered: prefixMouse.containsMouse
    readonly property bool sortHovered: sortMouse.containsMouse

    signal prefixClicked()
    signal sortClicked()

    implicitWidth: badgeRow.implicitWidth
    implicitHeight: badgeRow.implicitHeight

    DropShadow {
        anchors.fill: badgeRow
        source: badgeRow
        horizontalOffset: 0
        verticalOffset: 2
        radius: 5
        samples: 11
        color: "#38000000"
    }

    Row {
        id: badgeRow
        spacing: 10

        Item {
            visible: prefixText !== ""
            width: prefixLabel.width + 20
            height: Math.round(textPixelSize * 1.85)

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: prefixMouse.containsMouse ? hoverBackgroundColor : "transparent"
                border.width: 1
                border.color: prefixMouse.containsMouse ? hoverBorderColor : "transparent"
            }

            Text {
                id: prefixLabel
                anchors.centerIn: parent
                text: prefixText
                color: prefixMouse.containsMouse ? hoverTextColor : textColor
                font.family: fontFamily
                font.pixelSize: textPixelSize
            }

            MouseArea {
                id: prefixMouse
                anchors.fill: parent
                enabled: root.mouseEnabled
                hoverEnabled: root.mouseEnabled
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onClicked: root.prefixClicked()
            }
        }

        Item {
            width: sortContent.width + 20
            height: Math.round(textPixelSize * 1.85)

            Rectangle {
                anchors.fill: parent
                radius: 6
                color: sortMouse.containsMouse ? hoverBackgroundColor : "transparent"
                border.width: 1
                border.color: sortMouse.containsMouse ? hoverBorderColor : "transparent"
            }

            Row {
                id: sortContent
                anchors.centerIn: parent
                spacing: 10

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: labelText
                    color: sortMouse.containsMouse ? hoverTextColor : textColor
                    font.family: fontFamily
                    font.pixelSize: textPixelSize
                }

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 9

                    Item {
                        anchors.verticalCenter: parent.verticalCenter
                        width: Math.round(textPixelSize * 1.16)
                        height: width

                        Image {
                            anchors.centerIn: parent
                            source: iconSource
                            width: parent.width * iconScale
                            height: width
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                            asynchronous: true
                            opacity: sortMouse.containsMouse ? 1.0 : 0.82
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: valueText
                        color: sortMouse.containsMouse ? hoverTextColor : textColor
                        font.family: fontFamily
                        font.pixelSize: textPixelSize
                    }
                }
            }

            MouseArea {
                id: sortMouse
                anchors.fill: parent
                enabled: root.mouseEnabled
                hoverEnabled: root.mouseEnabled
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton
                onClicked: root.sortClicked()
            }
        }
    }
}
