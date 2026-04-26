import QtQuick 2.15

Item {
    id: root

    property bool optionsOpen: false
    property bool launchAnimating: false

    signal closeOptionsRequested()
    signal toggleOptionsRequested()
    signal cycleSortRequested()
    signal cycleCollectionRequested(int step)
    signal optionMoveRequested(int step)
    signal optionAdjustRequested(int step)
    signal selectionMoveRequested(int dx, int dy)
    signal launchRequested()

    Keys.onPressed: {
        if (launchAnimating) {
            event.accepted = true
            return
        }

        if (optionsOpen && event.key === Qt.Key_Escape) {
            event.accepted = true
            closeOptionsRequested()
            return
        }

        if (event.key === Qt.Key_O || event.key === Qt.Key_F1) {
            event.accepted = true
            toggleOptionsRequested()
            return
        }

        if (event.key === Qt.Key_S) {
            event.accepted = true
            cycleSortRequested()
            return
        }

        if (!optionsOpen && event.key === Qt.Key_PageUp) {
            event.accepted = true
            cycleCollectionRequested(-1)
            return
        }

        if (!optionsOpen && event.key === Qt.Key_PageDown) {
            event.accepted = true
            cycleCollectionRequested(1)
            return
        }

        if (optionsOpen) {
            if (event.key === Qt.Key_Up) {
                event.accepted = true
                optionMoveRequested(-1)
                return
            }
            if (event.key === Qt.Key_Down) {
                event.accepted = true
                optionMoveRequested(1)
                return
            }
            if (event.key === Qt.Key_Left) {
                event.accepted = true
                optionAdjustRequested(-1)
                return
            }
            if (event.key === Qt.Key_Right) {
                event.accepted = true
                optionAdjustRequested(1)
                return
            }
            return
        }

        if (event.key === Qt.Key_Left) {
            event.accepted = true
            selectionMoveRequested(-1, 0)
            return
        }
        if (event.key === Qt.Key_Right) {
            event.accepted = true
            selectionMoveRequested(1, 0)
            return
        }
        if (event.key === Qt.Key_Up) {
            event.accepted = true
            selectionMoveRequested(0, -1)
            return
        }
        if (event.key === Qt.Key_Down) {
            event.accepted = true
            selectionMoveRequested(0, 1)
            return
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            event.accepted = true
            if (launchAnimating || optionsOpen)
                return

            launchRequested()
            return
        }

        if (launchAnimating) {
            event.accepted = true
            return
        }

        if (optionsOpen && event.key === Qt.Key_Escape) {
            event.accepted = true
        }
    }
}
