import QtQuick 2.15
import "../ui" as UI

Item {
    id: root

    property bool blocked: false
    property bool animating: false
    property var pendingGame: null
    property var allGamesModel: null

    readonly property alias sourceHidden: animationLayer.sourceHidden

    function sameGame(left, right) {
        if (!left || !right)
            return false

        if (left.title !== right.title)
            return false

        if (left.sortBy !== undefined && right.sortBy !== undefined && left.sortBy !== right.sortBy)
            return false

        if (left.file !== undefined && right.file !== undefined)
            return left.file === right.file

        return true
    }

    function originalGameFor(game) {
        if (!game)
            return null

        if (typeof game.launch === "function")
            return game

        if (!allGamesModel || !allGamesModel.count || !allGamesModel.get)
            return null

        for (var i = 0; i < allGamesModel.count; ++i) {
            var candidate = allGamesModel.get(i)
            if (sameGame(game, candidate) && typeof candidate.launch === "function")
                return candidate
        }

        return null
    }

    function launchPendingGame() {
        var game = originalGameFor(pendingGame)
        if (game)
            game.launch()
    }

    function startLaunch(game, sourceItem, fallbackWidth, fallbackHeight) {
        if (!game)
            return

        blocked = true
        pendingGame = game
        animating = true
        animationLayer.sourceHidden = false
        animationLayer.placeOverSource(sourceItem, animationLayer, fallbackWidth, fallbackHeight)
        animationLayer.coverOpacity = 0.96
        animationLayer.coverScale = 1.0
        animationLayer.coverOpacity = 1.0
        animationLayer.coverScale = 1.12

        cooldownTimer.restart()
        hideSourceDelay.restart()
        coverSettleTimer.restart()
        launchDelayTimer.restart()
        resetTimer.restart()
    }

    function reset() {
        animating = false
        pendingGame = null
        animationLayer.sourceHidden = false
        animationLayer.clearSource()
        animationLayer.coverOpacity = 0.0
        animationLayer.coverScale = 1.0
    }

    Timer {
        id: cooldownTimer
        interval: 900
        repeat: false
        onTriggered: root.blocked = false
    }

    Timer {
        id: launchDelayTimer
        interval: 420
        repeat: false
        onTriggered: root.launchPendingGame()
    }

    Timer {
        id: hideSourceDelay
        interval: 34
        repeat: false
        onTriggered: animationLayer.sourceHidden = true
    }

    Timer {
        id: coverSettleTimer
        interval: 170
        repeat: false
        onTriggered: {
            animationLayer.coverOpacity = 0.98
            animationLayer.coverScale = 1.03
        }
    }

    Timer {
        id: resetTimer
        interval: 640
        repeat: false
        onTriggered: root.reset()
    }

    UI.LaunchAnimation {
        id: animationLayer
        anchors.fill: parent
        active: root.animating
    }
}
