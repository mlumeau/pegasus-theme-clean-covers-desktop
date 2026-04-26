import QtQuick 2.15
import "../js/ThemeConfig.js" as ThemeConfig
import "../js/ThemeSettings.js" as ThemeSettings
import "../js/ThemeSort.js" as ThemeSort

QtObject {
    property int sortMode: ThemeConfig.settingsDefaults.sortMode
    property bool sortAscending: ThemeSort.defaultAscending(sortMode)
    property real bgBlur: ThemeConfig.settingsDefaults.bgBlur
    property real bgDark: ThemeConfig.settingsDefaults.bgDark
    property color bgFallbackColor: ThemeConfig.settingsDefaults.bgFallbackColor
    property bool bgMotionEnabled: ThemeConfig.settingsDefaults.bgMotionEnabled
    property bool gameListScrollbarEnabled: ThemeConfig.settingsDefaults.gameListScrollbarEnabled
    property bool soundEnabled: ThemeConfig.settingsDefaults.soundEnabled
    property bool acceptReady: true

    readonly property var fallbackColors: ThemeConfig.fallbackColors

    function save(memory) {
        ThemeSettings.save(memory, {
            sortMode: sortMode,
            sortAscending: sortAscending,
            bgBlur: bgBlur,
            bgDark: bgDark,
            bgFallbackColor: bgFallbackColor,
            bgMotionEnabled: bgMotionEnabled,
            gameListScrollbarEnabled: gameListScrollbarEnabled,
            soundEnabled: soundEnabled
        })
    }

    function load(memory) {
        var loaded = ThemeSettings.load(memory, ThemeConfig.settingsDefaults, ThemeSort.defaultAscending)
        sortMode = loaded.sortMode
        sortAscending = loaded.sortAscending
        bgBlur = loaded.bgBlur
        bgDark = loaded.bgDark
        bgFallbackColor = loaded.bgFallbackColor
        bgMotionEnabled = loaded.bgMotionEnabled
        gameListScrollbarEnabled = loaded.gameListScrollbarEnabled
        soundEnabled = loaded.soundEnabled
    }
}
