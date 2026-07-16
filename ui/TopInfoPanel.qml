import QtQuick 2.15
import QtGraphicalEffects 1.15

Column {
    property string titleValue: ""
    property color titleColor: "white"
    property string condensedFontFamily: ""
    property int titlePixelSize: 60
    readonly property real titleVerticalCenter: titleItem.y + titleItem.height * 0.5

    spacing: 0

    Item {
        width: parent.width
        height: titleItem.height

        DropShadow {
            anchors.fill: titleItem
            source: titleItem
            horizontalOffset: 0
            verticalOffset: 2
            radius: 8
            samples: 17
            color: "#68000000"
        }

        Text {
            id: titleItem
            text: parent.parent.titleValue
            color: parent.parent.titleColor
            font.family: parent.parent.condensedFontFamily
            font.pixelSize: parent.parent.titlePixelSize
            elide: Text.ElideRight
            width: parent.width
        }
    }

}
