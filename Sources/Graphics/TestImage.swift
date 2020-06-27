//
// Created by Paul Sobolik on 2020-06-27.
//

import Foundation
import SwiftImage

class TestImage {
    var image: Image<RGBA<UInt8>>

    init(width: Int, height: Int, bg: RGBA<UInt8>) {
        image = Image(width: width, height: height, pixel: bg)
    }

    func saveToFile(atPath: String, imageFormat: ImageFormat = ImageFormat.png) -> Bool {
        guard let data: Data = image.data(using: imageFormat) else {
            return false
        }
        FileManager.default.createFile(atPath: atPath, contents: data)
        return true
    }

    private func plotPoint(x: Int, y: Int, image: inout Image<RGBA<UInt8>>, pixel: RGBA<UInt8>) {
        if image.xRange.contains(x) && image.yRange.contains(y) {
            image[x, y] = pixel
        }
    }

    func addDiagonals(pixel: RGBA<UInt8>) {
        var left, top, extent: Int
        if image.width > image.height {
            extent = image.height
            left = (image.width - image.height) / 2
            top = 0
        } else {
            extent = image.width
            left = 0
            top = (image.height - image.width) / 2
        }
        // Left top to right bottom
        Graphics.plotLine(xStart: left, yStart: top, xEnd: left + extent, yEnd: top + extent) { (x, y) in
            plotPoint(x: x, y: y, image: &image, pixel: pixel)
        }
        // Left bottom to right top
        Graphics.plotLine(xStart: left, yStart: top + extent, xEnd: left + extent, yEnd: top) { (x, y) in
            plotPoint(x: x, y: y, image: &image, pixel: pixel)
        }
    }

    func addVerticals(steps: Int, pixel: RGBA<UInt8>) {
        for i in stride(from: 0, to: image.width + 1, by: steps) {
            Graphics.plotLine(xStart: i, yStart: 0, xEnd: i, yEnd: image.height) { (x, y) in
                plotPoint(x: x, y: y, image: &image, pixel: pixel)
            }
        }
    }

    func drawHorizontals(steps: Int, pixel: RGBA<UInt8>) {
        for i in stride(from: 0, to: image.height + 1, by: steps) {
            Graphics.plotLine(xStart: 0, yStart: i, xEnd: image.width, yEnd: i) { (x, y) in
                plotPoint(x: x, y: y, image: &image, pixel: RGBA.red)
            }
        }
    }

    func addRadials(steps: Int, pixel: RGBA<UInt8>) {
        for i in stride(from: 0, to: image.height, by: steps) {
            Graphics.plotLine(xStart: 0, yStart: i, xEnd: image.width - 1, yEnd: image.height - 1 - i) { (x, y) in
                plotPoint(x: x, y: y, image: &image, pixel: pixel)
            }
        }
        for i in stride(from: 0, to: image.width + 1, by: steps) {
            Graphics.plotLine(xStart: i, yStart: 0, xEnd: image.width - 1 - i, yEnd: image.height - 1) { (x, y) in
                plotPoint(x: x, y: y, image: &image, pixel: pixel)
            }
        }
    }
}