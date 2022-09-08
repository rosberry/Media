//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation
import UIKit
import Texstyle

public struct ActionButtonAppearance {

    public enum ButtonType {
        case more
        case setting
        case custom
    }

    var type: ButtonType?
    var title: String
    var titleStyle: TextStyle
    var lineColor: UIColor?
    var backgroundColor: UIColor
    var cornerRadius: Double

    public init(type: ButtonType? = nil,
                title: String,
                titleStyle: TextStyle = .button1B,
                lineColor: UIColor? = .main1A,
                backgroundColor: UIColor = .clear,
                cornerRadius: Double = 0) {
        self.type = type
        self.title = title
        self.titleStyle = titleStyle
        self.lineColor = lineColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}
