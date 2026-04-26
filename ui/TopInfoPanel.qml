import QtQuick 2.15
import QtGraphicalEffects 1.15

Column {
    property string titleValue: ""
    property string secondaryValue: ""
    property string metaValue: ""
    property color titleColor: "white"
    property color secondaryColor: "#d8d8d8"
    property color metaColor: "#92ffffff"
    property string condensedFontFamily: ""
    property string sansFontFamily: ""
    property int titlePixelSize: 60
    property int secondaryPixelSize: 22
    property int metaPixelSize: 18
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

    Item {
        width: parent.width
        height: metaItem.height

        DropShadow {
            visible: metaItem.text !== ""
            anchors.fill: metaItem
            source: metaItem
            horizontalOffset: 0
            verticalOffset: 2
            radius: 5
            samples: 11
            color: "#38000000"
        }

        Text {
            id: metaItem
            visible: text !== ""
            text: parent.parent.metaValue
            color: parent.parent.metaColor
            font.family: parent.parent.sansFontFamily
            font.pixelSize: parent.parent.metaPixelSize
            elide: Text.ElideRight
            width: parent.width
            height: parent.parent.metaPixelSize + 2
        }
    }

    Item {
        width: parent.width
        height: secondaryItem.text !== "" ? secondaryItem.height : 0
        visible: secondaryItem.text !== ""

        DropShadow {
            anchors.fill: secondaryItem
            source: secondaryItem
            horizontalOffset: 0
            verticalOffset: 2
            radius: 5
            samples: 11
            color: "#48000000"
        }

        Text {
            id: secondaryItem
            text: parent.parent.secondaryValue
            color: parent.parent.secondaryColor
            font.family: parent.parent.sansFontFamily
            font.pixelSize: parent.parent.secondaryPixelSize
            elide: Text.ElideRight
            width: parent.width
        }
    }
}
