//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

extension UIImage {

    var aspect: CGFloat {
        return size.width / size.height
    }

    var isLandscape: Bool {
        return aspect > 1.0
    }

    var transform: CGAffineTransform {
        var transform: CGAffineTransform = .identity

        switch imageOrientation {
            case .up:
                return transform
            case .down, .downMirrored:
                transform = transform.translatedBy(x: size.width, y: size.height)
                transform = transform.rotated(by: .pi)
            case .left, .leftMirrored:
                transform = transform.translatedBy(x: size.width, y: 0.0)
                transform = transform.rotated(by: -.pi / 2.0)
            case .right, .rightMirrored:
                transform = transform.translatedBy(x: 0.0, y: size.height)
                transform = transform.rotated(by: .pi / 2.0)
            case .upMirrored:
                break
            @unknown default:
                break
        }

        switch imageOrientation {
            case .upMirrored, .downMirrored:
                transform = transform.translatedBy(x: size.width, y: 0.0)
                transform = transform.scaledBy(x: -1.0, y: 1.0)
            case .leftMirrored, .rightMirrored:
                transform = transform.translatedBy(x: 0.0, y: size.height)
                transform = transform.scaledBy(x: 1.0, y: -1.0)
            default:
                break
        }

        return transform
    }
}
