import QtQuick 2.15
import QtGraphicalEffects 1.15
import "../js/ThemeSort.js" as ThemeSort
import "../ui" as UI

Item {
    id: root

    property bool gameListScrollbarEnabled: true
    property bool mouseEnabled: true
    property var gamesModel
    property string collectionName: "All games"
    property color bgFallbackColor: "#2a2d32"

    property color colorTextPrimary: "white"
    property color colorTextSecondary: "#d8d8d8"
    property color colorTextMuted: "#92ffffff"
    property color colorTextInactive: "#d0d0d0"
    property color colorTextPlaceholder: "#f0f0f0"
    property color colorTextSort: "#92ffffff"
    property color colorCardBase: "#161616"
    property int sortMode: 0
    property bool sortAscending: false

    property string condensedFontFamily: ""
    property string sansFontFamily: ""

    property var coverSourceFn
    property var secondaryTextFn
    property var metaTextFn

    readonly property int currentIndex: gridView.currentIndex
    readonly property var currentGame: modelGame(currentIndex)
    readonly property var currentLaunchVisual: currentIndex >= 0 && gridView.itemAtIndex(currentIndex)
        ? gridView.itemAtIndex(currentIndex).launchVisual
        : (gridView.currentItem ? gridView.currentItem.launchVisual : null)
    readonly property real currentLaunchFallbackWidth: Math.round(gridView.posterWidth)
    readonly property real currentLaunchFallbackHeight: Math.round(gridView.posterHeight)

    signal navigateRequested()
    signal launchRequested()
    signal focusRequested()
    signal cycleCollectionRequested(int step)
    signal cycleSortRequested()
    signal optionsRequested()

    function setCurrentIndex(index) {
        var next = Math.max(0, Math.min(index, Math.max(0, gamesModel ? gamesModel.count - 1 : 0)))
        var previous = currentIndex
        gridView.currentIndex = next
        return next !== previous
    }

    function modelGame(index) {
        if (gamesModel && gamesModel.count > index && index >= 0 && gamesModel.get)
            return gamesModel.get(index)

        return gridView.currentItem ? gridView.currentItem.gameObj : null
    }

    function moveSelection(dx, dy) {
        var cols = Math.max(1, gridView.columns)
        return setCurrentIndex(gridView.currentIndex + dx + dy * cols)
    }

    function resetIndexes() {
        gridView.currentIndex = 0
    }

    anchors.topMargin: Math.round(parent.width * 0.035)
    anchors.leftMargin: Math.round(parent.width * 0.035)
    anchors.rightMargin: Math.round(parent.width * 0.035)

    Item {
        id: headerBlock
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.max(topBlock.height, headerActions.height)

        UI.TopInfoPanel {
            id: topBlock
            anchors.left: parent.left
            anchors.right: headerActions.left
            anchors.rightMargin: 8
            height: implicitHeight
            titleValue: root.currentGame ? root.currentGame.title : "No games"
            secondaryValue: secondaryTextFn ? secondaryTextFn(root.currentGame) : ""
            metaValue: metaTextFn ? metaTextFn(root.currentGame) : ""
            titleColor: colorTextPrimary
            secondaryColor: colorTextSecondary
            metaColor: colorTextMuted
            condensedFontFamily: root.condensedFontFamily
            sansFontFamily: root.sansFontFamily
            titlePixelSize: 48
            secondaryPixelSize: 22
            metaPixelSize: 18
        }

        Row {
            id: headerActions
            x: parent.width - width
            y: Math.round(topBlock.titleVerticalCenter - height * 0.5)
            spacing: 10
            height: sortBadgeWrap.height

            UI.SortBadge {
                id: sortBadgeWrap
                width: implicitWidth
                height: implicitHeight
                textColor: colorTextSort
                fontFamily: root.sansFontFamily
                textPixelSize: 17
                prefixText: root.collectionName
                valueText: ThemeSort.displayName(sortMode, sortAscending)
                iconSource: ThemeSort.iconSource(sortMode)
                iconScale: ThemeSort.iconScale(sortMode)
                mouseEnabled: root.mouseEnabled
                onPrefixClicked: root.cycleCollectionRequested(1)
                onSortClicked: root.cycleSortRequested()
            }

            Item {
                id: settingsButton
                anchors.verticalCenter: parent.verticalCenter
                width: sortBadgeWrap.height
                height: width

                Rectangle {
                    anchors.fill: parent
                    radius: 6
                    color: settingsMouse.containsMouse ? "#18ffffff" : "transparent"
                    border.width: 1
                    border.color: settingsMouse.containsMouse ? "#30ffffff" : "transparent"
                }

                Image {
                    anchors.centerIn: parent
                    source: "../assets/ui/cog.svg"
                    width: Math.round(parent.width * 0.48)
                    height: width
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                    asynchronous: true
                    opacity: settingsMouse.containsMouse ? 1.0 : 0.82
                }

                MouseArea {
                    id: settingsMouse
                    anchors.fill: parent
                    enabled: root.mouseEnabled
                    hoverEnabled: root.mouseEnabled
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    onClicked: if (root.mouseEnabled) root.optionsRequested()
                }
            }
        }
    }

    Item {
        id: gridFadeArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: headerBlock.bottom
        anchors.topMargin: 18
        anchors.bottom: parent.bottom
        readonly property real fadeInset: root.height * 0.045
        layer.enabled: visible
        layer.effect: OpacityMask {
            maskSource: Item {
                width: gridFadeArea.width
                height: gridFadeArea.height

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    height: gridFadeArea.fadeInset
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#00ffffff" }
                        GradientStop { position: 1.0; color: "#ffffffff" }
                    }
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.topMargin: gridFadeArea.fadeInset
                    anchors.bottom: parent.bottom
                    color: "#ffffffff"
                }
            }
        }

        GridView {
            id: gridView
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.rightMargin: 52
            anchors.top: parent.top
            anchors.topMargin: gridFadeArea.fadeInset
            anchors.bottom: parent.bottom

            model: gamesModel
            clip: false
            flow: GridView.FlowLeftToRight
            cellWidth: Math.max(210, Math.min(285, Math.floor(width / 5)))
            cellHeight: Math.round(posterHeight + rowGutter)
            interactive: root.mouseEnabled
            boundsBehavior: Flickable.StopAtBounds
            flickableDirection: Flickable.VerticalFlick
            maximumFlickVelocity: 3200
            flickDeceleration: 4200
            highlightMoveDuration: 120
            currentIndex: 0
            bottomMargin: 36

            readonly property real posterWidth: cellWidth * 0.90
            readonly property real posterHeight: posterWidth * 1.5
            readonly property real rowGutter: 70
            readonly property int columns: Math.max(1, Math.floor(width / cellWidth))

            delegate: UI.GridGameCard {
                width: gridView.cellWidth
                height: gridView.cellHeight
                gameObj: modelData
                posterSource: coverSourceFn ? coverSourceFn(modelData) : ""
                selected: GridView.isCurrentItem
                cardBaseColor: colorCardBase
                fallbackBackgroundColor: bgFallbackColor
                placeholderTextColor: colorTextPlaceholder
                inactiveTextColor: colorTextInactive
                condensedFontFamily: root.condensedFontFamily
                sansFontFamily: root.sansFontFamily
                posterTitlePixelSize: 26
                labelPixelSize: 18
                mouseEnabled: root.mouseEnabled

                onClicked: {
                    if (!root.mouseEnabled)
                        return
                    var previousY = gridView.contentY
                    gridView.currentIndex = index
                    gridView.contentY = previousY
                    root.navigateRequested()
                    root.focusRequested()
                }
                onLaunchRequested: {
                    root.focusRequested()
                    root.launchRequested()
                }
            }

            highlightRangeMode: GridView.NoHighlightRange
        }

    }

    UI.GameListScrollbar {
        visible: gameListScrollbarEnabled && gridView.contentHeight > gridView.height
        x: gridFadeArea.width - Math.round(root.anchors.rightMargin * 0.28) - width * 0.5
        anchors.verticalCenter: gridFadeArea.verticalCenter
        width: 6
        height: Math.min(gridFadeArea.height * 0.50, Math.round(root.height * 0.40))
        vertical: true
        normalizedPosition: gridView.visibleArea.heightRatio < 1.0
            ? gridView.visibleArea.yPosition / Math.max(0.001, 1.0 - gridView.visibleArea.heightRatio)
            : 0
        thumbRatio: gridView.visibleArea.heightRatio
        minThumbSize: 28
    }

}
