import AppKit
import Foundation

let root = FileManager.default.currentDirectoryPath
let sourcePath = "\(root)/assets/icon/app_icon.png"
let outPath = "\(root)/appstore_assets/icon/app_store_icon_1024.png"

guard let source = NSImage(contentsOfFile: sourcePath) else {
    fputs("Cannot load source icon: \(sourcePath)\n", stderr)
    exit(1)
}

let size = NSSize(width: 1024, height: 1024)
let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: 1024,
    pixelsHigh: 1024,
    bitsPerSample: 8,
    samplesPerPixel: 3,
    hasAlpha: false,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
)!

NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

NSColor.black.setFill()
NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

source.draw(in: NSRect(x: 0, y: 0, width: 1024, height: 1024))

NSGraphicsContext.restoreGraphicsState()

guard let pngData = rep.representation(using: .png, properties: [:]) else {
    fputs("Failed to encode PNG\n", stderr)
    exit(1)
}

try pngData.write(to: URL(fileURLWithPath: outPath))
print("Generated: \(outPath)")
