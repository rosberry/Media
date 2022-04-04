//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

public struct CellAppearance {
    public var contentViewCornerRadius: Double
    public var contentViewColor: UIColor
    public var infoViewCornerRadius: Double
    public var infoViewAlpha: Double
    public var infoViewBackgroundColor: UIColor
    public var selectedColor: UIColor
    public var highlightedColor: UIColor

    public init(contentViewCornerRadius: Double = 0,
                contentViewColor: UIColor = .main3A,
                infoViewCornerRadius: Double = 0,
                infoViewAlpha: Double = 1,
                infoViewBackgroundColor: UIColor = .clear,
                selectedColor: UIColor = .white,
                highlightedColor: UIColor = .clear) {
        self.contentViewCornerRadius = contentViewCornerRadius
        self.contentViewColor = contentViewColor
        self.infoViewCornerRadius = infoViewCornerRadius
        self.infoViewAlpha = infoViewAlpha
        self.infoViewBackgroundColor = infoViewBackgroundColor
        self.selectedColor = selectedColor
        self.highlightedColor = highlightedColor
    }
}
