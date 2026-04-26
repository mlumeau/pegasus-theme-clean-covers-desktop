import QtQuick 2.15
import "../js/ThemeOptions.js" as ThemeOptions

Item {
    id: root

    property bool open: false
    property int currentIndex: 0

    property int sortMode: 0
    property bool sortAscending: false
    property real bgBlur: 18
    property real bgDark: 0.35
    property color bgFallbackColor: "#2a2d32"
    property bool bgMotionEnabled: true
    property bool gameListScrollbarEnabled: true
    property bool soundEnabled: true
    property var fallbackColors: []

    property var sortDisplayNameFn
    property var fallbackColorNameFn

    signal opened()
    signal closed()
    signal navigateRequested()
    signal cycleSortRequested(int step)
    signal adjustBlurRequested(real step)
    signal adjustDarkRequested(real step)
    signal cycleFallbackColorRequested(int step)
    signal toggleMotionRequested()
    signal toggleGameListScrollbarRequested()
    signal toggleSoundRequested()

    function optionCount() { return ThemeOptions.optionCount() }
    function menuLabel(index) { return ThemeOptions.menuLabel(index) }

    function menuValue(index) {
        return ThemeOptions.menuValue(index, {
            sortMode: sortMode,
            sortAscending: sortAscending,
            bgBlur: bgBlur,
            bgDark: bgDark,
            bgFallbackColor: bgFallbackColor,
            bgMotionEnabled: bgMotionEnabled,
            gameListScrollbarEnabled: gameListScrollbarEnabled,
            soundEnabled: soundEnabled,
            fallbackColors: fallbackColors
        }, {
            sortDisplayName: sortDisplayNameFn,
            fallbackColorName: fallbackColorNameFn
        })
    }

    function openMenu() {
        open = true
        currentIndex = 0
        opened()
    }

    function closeMenu() {
        open = false
        closed()
    }

    function moveCurrent(step) {
        currentIndex = (currentIndex + step + optionCount()) % optionCount()
        navigateRequested()
    }

    function setCurrent(index) {
        var next = Math.max(0, Math.min(index, optionCount() - 1))
        if (next === currentIndex)
            return
        currentIndex = next
        navigateRequested()
    }

    function adjustCurrent(step) {
        adjustIndex(currentIndex, step)
    }

    function adjustIndex(index, step) {
        currentIndex = Math.max(0, Math.min(index, optionCount() - 1))
        switch (currentIndex) {
            case 0: cycleSortRequested(step); break
            case 1: adjustBlurRequested(step * 2); break
            case 2: adjustDarkRequested(step * 0.05); break
            case 3: cycleFallbackColorRequested(step); break
            case 4: if (step !== 0) toggleMotionRequested(); break
            case 5: if (step !== 0) toggleGameListScrollbarRequested(); break
            case 6: if (step !== 0) toggleSoundRequested(); break
        }
    }
}
