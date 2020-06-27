//
// Created by Paul Sobolik on 2020-06-26.
//

import Foundation

struct Graphics {
    private static func _octant0(xStart: Int, yStart: Int, deltaX: Int, deltaY: Int, direction: Int, _ plotDot: (Int, Int) -> Void) {
        let deltaYx2 = deltaY * 2
        let deltaYx2MinusDeltaXx2 = deltaYx2 - (deltaX * 2)

        var error = deltaYx2 - deltaX
        var x = xStart
        var y = yStart
        var dx = deltaX

        plotDot(x, y)

        while dx > 0 {
            if error >= 0 {
                y += 1
                error += deltaYx2MinusDeltaXx2
            } else {
                error += deltaYx2
            }
            x += direction
            plotDot(x, y)
            dx -= 1
        }
    }

    private static func _octant1(xStart: Int, yStart: Int, deltaX: Int, deltaY: Int, direction: Int, _ plotDot: (Int, Int) -> Void) {
        let deltaXx2 = deltaX * 2
        let deltaXx2MinusDeltaYx2 = deltaXx2 - (deltaY * 2)

        var error = deltaXx2 - deltaY
        var x = xStart
        var y = yStart
        var dy = deltaY

        plotDot(x, y)

        while dy > 0 {
            if error >= 0 {
                x += direction
                error += deltaXx2MinusDeltaYx2
            } else {
                error += deltaXx2
            }
            y += 1
            plotDot(x, y)
            dy -= 1
        }
    }

    private static func _plotLine(xStart: Int, yStart: Int, xEnd: Int, yEnd: Int, _ plotDot: (Int, Int) -> Void) {
        let deltaX = xEnd - xStart
        let deltaY = yEnd - yStart

        if deltaX > 0 {
            if deltaX > deltaY {
                _octant0(xStart: xStart, yStart: yStart, deltaX: deltaX, deltaY: deltaY, direction: 1, plotDot)
            } else {
                _octant1(xStart: xStart, yStart: yStart, deltaX: deltaX, deltaY: deltaY, direction: 1, plotDot)
            }
        } else {
            let dX = -deltaX
            if dX > deltaY {
                _octant0(xStart: xStart, yStart: yStart, deltaX: dX, deltaY: deltaY, direction: -1, plotDot)
            } else {
                _octant1(xStart: xStart, yStart: yStart, deltaX: dX, deltaY: deltaY, direction: -1, plotDot)
            }
        }
    }

    private static func _plotLineHorizontal(xStart: Int, xEnd: Int, y: Int, _ plotDot: (Int, Int) -> Void) {
        let bump = xStart > xEnd ? -1 : 1
        var x = xStart
        while x < xEnd {
            plotDot(x, y)
            x += bump
        }
    }

    private static func _plotLineVertical(yStart: Int, yEnd: Int, x: Int, _ plotDot: (Int, Int) -> Void) {
        let bump = yStart > yEnd ? -1 : 1
        var y = yStart
        while y < yEnd {
            plotDot(x, y)
            y += bump
        }
    }
    private static func _plotLineDiagonal(xStart: Int, yStart: Int, xEnd: Int, yEnd: Int, _ plotDot: (Int, Int) -> Void) {
        let dX = xStart > xEnd ? -1 : 1
        let dY = yStart > yEnd ? -1 : 1

        var x = xStart
        var y = yStart

        while x < xEnd {
            plotDot(x, y)
            x += dX
            y += dY
        }
    }
    static func plotLine(xStart: Int, yStart: Int, xEnd: Int, yEnd: Int, _ plotDot: (Int, Int) -> Void) {
        if abs(xEnd - xStart) == abs(yEnd - yStart) {
            _plotLineDiagonal(xStart: xStart, yStart: yStart, xEnd: xEnd, yEnd: yEnd, plotDot)
        } else if yStart == yEnd {
            _plotLineHorizontal(xStart: xStart, xEnd: xEnd, y: yStart, plotDot)
        } else if xStart == xEnd {
            _plotLineVertical(yStart: yStart, yEnd: yEnd, x: xStart, plotDot)
        } else if yStart < yEnd {
            _plotLine(xStart: xStart, yStart: yStart, xEnd: xEnd, yEnd: yEnd, plotDot)
        } else {
            _plotLine(xStart: xEnd, yStart: yEnd, xEnd: xStart, yEnd: yStart, plotDot)
        }
    }
}

extension Graphics {
    static func _plotCircle(xCenter: Int, yCenter: Int, radius: Int, width: Int = 1, _ plotDot: (Int, Int) -> Void) {
        var o: Int = width / 2 - width
        for i in 0..<width {
            _plotCircle(xCenter: xCenter, yCenter: yCenter, radius: radius + i + o, plotDot)
        }
    }
    static func plotCircle(xCenter: Int, yCenter: Int, radius: Int, _ plotDot: (Int, Int) -> Void) {
        var majorAxis = 0
        var minorAxis = radius
        var distance = radius * radius
        var minorAxisThreshold = minorAxis * minorAxis - minorAxis
        repeat {
            plotDot(xCenter + majorAxis, yCenter - minorAxis)
            plotDot(xCenter - majorAxis, yCenter - minorAxis)
            plotDot(xCenter + majorAxis, yCenter + minorAxis)
            plotDot(xCenter - majorAxis, yCenter + minorAxis)

            plotDot(xCenter + minorAxis, yCenter - majorAxis)
            plotDot(xCenter - minorAxis, yCenter - majorAxis)
            plotDot(xCenter + minorAxis, yCenter + majorAxis)
            plotDot(xCenter - minorAxis, yCenter + majorAxis)

            majorAxis += 1
            distance -= majorAxis + majorAxis + 1
            if distance <= minorAxisThreshold {
                minorAxis -= 1
                minorAxisThreshold -= minorAxis + minorAxis
            }
        } while majorAxis <= minorAxis
    }
}