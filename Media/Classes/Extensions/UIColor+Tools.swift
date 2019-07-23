//
//  Copyright © 2017 Rosberry. All rights reserved.
//

import UIKit

// swiftlint:disable identifier_name
public struct RGB {
    var r: CGFloat
    var g: CGFloat
    var b: CGFloat
}

public struct HSB {
    var h: CGFloat
    var s: CGFloat
    var b: CGFloat
}

public struct YUV {
    var y: CGFloat
    var u: CGFloat
    var v: CGFloat
}

public struct CMYK {
    var c: CGFloat
    var m: CGFloat
    var y: CGFloat
    var k: CGFloat
}
// swiftlint:enable identifier_name

extension UIColor {
    
    convenience init(red: UInt32, green: UInt32, blue: UInt32, alpha: UInt32) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha) / 255.0
        )
    }
    
    convenience init(rgba: UInt32) {
        self.init(
            red: (rgba >> 24) & 0xFF,
            green: (rgba >> 16) & 0xFF,
            blue: (rgba >> 8) & 0xFF,
            alpha: rgba & 0xFF
        )
    }
    
    // MARK: - Alpha
    
    public var alpha: CGFloat {
        var alpha: CGFloat = 0.0
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        return alpha
    }
    
    // MARK: - RGB
    
    public var rgb: RGB {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return RGB(r: red, g: green, b: blue)
    }
    
    // MARK: - HSB
    
    public var hsb: HSB {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return HSB(h: hue, s: saturation, b: brightness)
    }
    
    // MARK: - YUV
    
    public var yuv: YUV {
        let rgb = self.rgb
        let luminance = (0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b) // BT.601
        return YUV(y: luminance, u: rgb.b - luminance, v: rgb.r - luminance)
    }
    
    // MARK: - CMYK
    
    public var cmyk: CMYK {
        let rgb = self.rgb
        // swiftlint:disable identifier_name
        let k = 1.0 - max(rgb.r, rgb.g, rgb.b)
        let c = (1.0 - rgb.r - k) / (1.0 - k)
        let m = (1.0 - rgb.g - k) / (1.0 - k)
        // swiftlint:enable identifier_name
        let y = (1.0 - rgb.b - k) / (1.0 - k)
        return CMYK(c: c, m: m, y: y, k: k)
    }
}
