//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import CoreGraphics

extension CGRect {

    var aspect: CGFloat {
        return width / height
    }

    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }

    // MARK: - Edges

    var topLeft: CGPoint {
        return origin
    }

    var topMiddle: CGPoint {
        return CGPoint(x: midX, y: minY)
    }

    var topRight: CGPoint {
        return CGPoint(x: maxX, y: minY)
    }

    var middleLeft: CGPoint {
        return CGPoint(x: minX, y: midY)
    }

    var middleRight: CGPoint {
        return CGPoint(x: maxX, y: midY)
    }

    var bottomLeft: CGPoint {
        return CGPoint(x: minX, y: maxY)
    }

    var bottomMiddle: CGPoint {
        return CGPoint(x: midX, y: maxY)
    }

    var bottomRight: CGPoint {
        return CGPoint(x: maxX, y: maxY)
    }

    // MARK: - Initializers

    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2.0,
                  y: center.y - size.height / 2.0,
                  width: size.width,
                  height: size.height)
    }

    init(filling target: CGRect, aspect: CGFloat) {
        self.init()
        size = CGSize(width: aspect, height: 1.0)
        fill(rect: target)
    }

    init(fitting target: CGRect, aspect: CGFloat) {
        self.init()
        size = CGSize(width: aspect, height: 1.0)
        fit(rect: target)
    }

    static func reference() -> CGRect {
        return CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
    }

    // MARK: Fit / Fill

    func scaleToFit(rect: CGRect) -> CGFloat {
        let scale = rect.width / width
        if height * scale <= rect.height {
            return scale
        }

        return rect.height / height
    }

    func scaleToFill(rect: CGRect) -> CGFloat {
        return 1.0 / rect.scaleToFit(rect: self)
    }

    mutating func fit(rect: CGRect) {
        let scale = scaleToFit(rect: rect)
        size.width = width * scale
        size.height = height * scale
        origin.x = rect.midX - width / 2.0
        origin.y = rect.midY - height / 2.0
    }

    func fitting(rect: CGRect) -> CGRect {
        var result = self
        result.fit(rect: rect)
        return result
    }

    mutating func fill(rect: CGRect) {
        let scale = scaleToFill(rect: rect)
        size.width = width * scale
        size.height = height * scale
        origin.x = rect.midX - width / 2.0
        origin.y = rect.midY - height / 2.0
    }

    func filling(rect: CGRect) -> CGRect {
        var result = self
        result.fill(rect: rect)
        return result
    }

    // MARK: - Alignment

    func alignedForVideoExport() -> CGRect {
        let alignment: CGFloat = 16.0
        let alignedWidth = floor(width / alignment) * alignment
        let alignedHeight = round(0.5 * alignedWidth / aspect) * 2.0
        return CGRect(x: minX, y: minY, width: alignedWidth, height: alignedHeight)
    }

    // MARK: - Scale

    func scaled(byX x: CGFloat, y: CGFloat) -> CGRect {
        let width = self.width * x
        let height = self.height * y
        return CGRect(x: center.x - 0.5 * width, y: center.y - 0.5 * height, width: width, height: height)
    }

    // MARK: - Transpose

    mutating func transpose() {
        swap(&origin.x, &origin.y)
        swap(&size.width, &size.height)
    }
}
