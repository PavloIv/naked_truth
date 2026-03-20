import AppKit
import Foundation

struct Slide {
    let title: String
    let subtitle: String
    let imagePath: String
    let accent: NSColor
}

let root = FileManager.default.currentDirectoryPath
let outputRoot = "\(root)/appstore_assets/ios"

let slides: [Slide] = [
    Slide(
        title: "Speak Honestly",
        subtitle: "Cards to start real conversations",
        imagePath: "\(root)/assets/onboarding_image/onboarding1.png",
        accent: NSColor(calibratedRed: 0.97, green: 0.49, blue: 0.45, alpha: 1)
    ),
    Slide(
        title: "For Couples",
        subtitle: "Explore trust, intimacy, and boundaries",
        imagePath: "\(root)/assets/onboarding_image/onboarding2.png",
        accent: NSColor(calibratedRed: 0.36, green: 0.74, blue: 0.96, alpha: 1)
    ),
    Slide(
        title: "For Friends",
        subtitle: "Playful prompts for deeper connection",
        imagePath: "\(root)/assets/onboarding_image/onboarding3.png",
        accent: NSColor(calibratedRed: 0.39, green: 0.86, blue: 0.54, alpha: 1)
    ),
    Slide(
        title: "After Dark",
        subtitle: "Bold themes for adult sessions",
        imagePath: "\(root)/assets/onboarding_image/onboarding4.png",
        accent: NSColor(calibratedRed: 1.0, green: 0.75, blue: 0.25, alpha: 1)
    ),
    Slide(
        title: "Build Your Ritual",
        subtitle: "Save favorites and keep the flow going",
        imagePath: "\(root)/assets/icon/app_icon.png",
        accent: NSColor(calibratedRed: 0.74, green: 0.58, blue: 0.98, alpha: 1)
    )
]

struct RenderTarget {
    let name: String
    let width: Int
    let height: Int
}

let targets: [RenderTarget] = [
    RenderTarget(name: "6.9_inch", width: 1290, height: 2796),
    RenderTarget(name: "6.5_inch", width: 1242, height: 2688)
]

func draw(_ slide: Slide, target: RenderTarget, index: Int) throws {
    let width = CGFloat(target.width)
    let height = CGFloat(target.height)

    let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: target.width,
        pixelsHigh: target.height,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    )!

    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)

    let backgroundRect = NSRect(x: 0, y: 0, width: width, height: height)
    let gradient = NSGradient(
        colors: [
            NSColor(calibratedRed: 0.14, green: 0.08, blue: 0.38, alpha: 1),
            NSColor(calibratedRed: 0.07, green: 0.05, blue: 0.17, alpha: 1)
        ]
    )!
    gradient.draw(in: backgroundRect, angle: -90)

    slide.accent.withAlphaComponent(0.18).setFill()
    NSBezierPath(ovalIn: NSRect(x: width * 0.58, y: height * 0.68, width: width * 0.58, height: width * 0.58)).fill()
    slide.accent.withAlphaComponent(0.11).setFill()
    NSBezierPath(ovalIn: NSRect(x: -width * 0.22, y: -width * 0.08, width: width * 0.62, height: width * 0.62)).fill()

    let titleStyle = NSMutableParagraphStyle()
    titleStyle.alignment = .center

    let titleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: width * 0.075, weight: .bold),
        .foregroundColor: NSColor.white,
        .paragraphStyle: titleStyle
    ]

    let subtitleAttrs: [NSAttributedString.Key: Any] = [
        .font: NSFont.systemFont(ofSize: width * 0.038, weight: .medium),
        .foregroundColor: NSColor.white.withAlphaComponent(0.9),
        .paragraphStyle: titleStyle
    ]

    let titleRect = NSRect(x: width * 0.08, y: height * 0.86, width: width * 0.84, height: height * 0.08)
    let subtitleRect = NSRect(x: width * 0.11, y: height * 0.81, width: width * 0.78, height: height * 0.06)

    NSString(string: slide.title).draw(in: titleRect, withAttributes: titleAttrs)
    NSString(string: slide.subtitle).draw(in: subtitleRect, withAttributes: subtitleAttrs)

    let phoneWidth = width * 0.78
    let phoneHeight = height * 0.63
    let phoneRect = NSRect(
        x: (width - phoneWidth) / 2,
        y: height * 0.16,
        width: phoneWidth,
        height: phoneHeight
    )

    NSColor(calibratedWhite: 0.05, alpha: 0.88).setFill()
    let shellPath = NSBezierPath(roundedRect: phoneRect, xRadius: width * 0.05, yRadius: width * 0.05)
    shellPath.fill()

    NSColor.white.withAlphaComponent(0.18).setStroke()
    shellPath.lineWidth = width * 0.003
    shellPath.stroke()

    let notchRect = NSRect(
        x: phoneRect.midX - phoneRect.width * 0.18,
        y: phoneRect.maxY - phoneRect.height * 0.04,
        width: phoneRect.width * 0.36,
        height: phoneRect.height * 0.025
    )
    NSColor(calibratedWhite: 0.02, alpha: 0.95).setFill()
    NSBezierPath(roundedRect: notchRect, xRadius: notchRect.height / 2, yRadius: notchRect.height / 2).fill()

    let contentInset = width * 0.028
    let contentRect = phoneRect.insetBy(dx: contentInset, dy: contentInset)
    let contentPath = NSBezierPath(roundedRect: contentRect, xRadius: width * 0.032, yRadius: width * 0.032)

    contentPath.addClip()

    if let image = NSImage(contentsOfFile: slide.imagePath) {
        let sourceSize = image.size
        let sourceAspect = sourceSize.width / max(1, sourceSize.height)
        let targetAspect = contentRect.width / max(1, contentRect.height)

        var drawRect = contentRect
        if sourceAspect > targetAspect {
            let scaledHeight = contentRect.width / sourceAspect
            drawRect.origin.y += (contentRect.height - scaledHeight) / 2
            drawRect.size.height = scaledHeight
        } else {
            let scaledWidth = contentRect.height * sourceAspect
            drawRect.origin.x += (contentRect.width - scaledWidth) / 2
            drawRect.size.width = scaledWidth
        }

        image.draw(in: drawRect)
    } else {
        slide.accent.withAlphaComponent(0.45).setFill()
        NSBezierPath(rect: contentRect).fill()
    }

    NSGraphicsContext.restoreGraphicsState()

    let outDir = "\(outputRoot)/\(target.name)"
    try FileManager.default.createDirectory(atPath: outDir, withIntermediateDirectories: true)
    let outPath = "\(outDir)/screenshot_0\(index + 1).png"

    guard let png = rep.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "generator", code: 2)
    }
    try png.write(to: URL(fileURLWithPath: outPath))
}

for target in targets {
    for (idx, slide) in slides.enumerated() {
        try draw(slide, target: target, index: idx)
    }
}

print("Generated \(slides.count) screenshots for \(targets.count) targets at \(outputRoot)")
