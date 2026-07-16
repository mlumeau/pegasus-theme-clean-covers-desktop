.pragma library

function clamp(v, a, b) {
    return Math.max(a, Math.min(b, v))
}

function randRange(minV, maxV) {
    return minV + Math.random() * (maxV - minV)
}

function randDifferent(start, minV, maxV, minDelta) {
    var value = randRange(minV, maxV)
    if (Math.abs(value - start) >= minDelta)
        return value

    var dir = value >= start ? 1 : -1
    value = clamp(start + dir * minDelta, minV, maxV)
    if (Math.abs(value - start) >= minDelta)
        return value

    return clamp(start - dir * minDelta, minV, maxV)
}

function fallbackColorName(currentColor, fallbackColors) {
    var current = currentColor.toString()
    for (var i = 0; i < fallbackColors.length; ++i) {
        if (fallbackColors[i].value === current)
            return fallbackColors[i].name
    }
    return "Custom"
}

function coverSource(game) {
    if (!game) return ""
    if (game.assets.poster) return game.assets.poster
    if (game.assets.boxFront) return game.assets.boxFront
    if (game.assets.tile) return game.assets.tile
    return ""
}

function bgSource(game) {
    if (!game) return ""
    if (game.assets.banner) return game.assets.banner
    if (game.assets.steam) return game.assets.steam
    if (game.assets.background) return game.assets.background
    if (game.assets.screenshot) return game.assets.screenshot
    if (game.assets.titlescreen) return game.assets.titlescreen
    return ""
}
