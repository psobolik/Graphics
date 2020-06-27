import SwiftImage
import Foundation

let testImage = TestImage(width: 1000, height: 800, bg: RGBA<UInt8>.white)
testImage.addVerticals(steps: 20, pixel: RGBA.green)
testImage.drawHorizontals(steps: 10, pixel: RGBA.magenta)
testImage.addRadials(steps: 20, pixel: RGBA.black)
testImage.addDiagonals(pixel: RGBA.black)

exit(testImage.saveToFile(atPath: NSString(string: "~/test-image.png").expandingTildeInPath) ? 0 : 1)
