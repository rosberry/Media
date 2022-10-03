//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public struct AssetCellAppearance {
    public var contentViewCornerRadius: Double
    public var contentViewColor: UIColor
    public var infoViewCornerRadius: Double
    public var infoTitleStyle: TextStyle
    public var infoViewBackgroundColor: UIColor
    public var selectedColor: UIColor
    public var highlightedColor: UIColor

    public init(contentViewCornerRadius: Double = 0,
                contentViewColor: UIColor = .clear,
                infoViewCornerRadius: Double = 4,
                infoViewBackgroundColor: UIColor = .main1A,
                infoTitleStyle: TextStyle = .subtitle1B,
                selectedColor: UIColor = .clear,
                highlightedColor: UIColor = .clear) {
        self.contentViewCornerRadius = contentViewCornerRadius
        self.contentViewColor = contentViewColor
        self.infoViewCornerRadius = infoViewCornerRadius
        self.infoViewBackgroundColor = infoViewBackgroundColor
        self.infoTitleStyle = infoTitleStyle
        self.selectedColor = selectedColor
        self.highlightedColor = highlightedColor
    }
}
