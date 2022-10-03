//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

public struct AlbumCellAppearance {
    public var titleStyle: TextStyle
    public var subtitleStyle: TextStyle
    public var imageCornerRadius: Double
    public var contentViewCornerRadius: Double
    public var contentViewColor: UIColor
    public var selectedColor: UIColor
    public var highlightedColor: UIColor

    public init(titleStyle: TextStyle = .title4A,
                subtitleStyle: TextStyle = .subtitle2C,
                imageCornerRadios: Double = 8.0,
                contentViewCornerRadius: Double = 0,
                contentViewColor: UIColor = .clear,
                selectedColor: UIColor = .clear,
                highlightedColor: UIColor = .clear) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
        self.imageCornerRadius = imageCornerRadios
        self.contentViewCornerRadius = contentViewCornerRadius
        self.contentViewColor = contentViewColor
        self.selectedColor = selectedColor
        self.highlightedColor = highlightedColor
    }
}
