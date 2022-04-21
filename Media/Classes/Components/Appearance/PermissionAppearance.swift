//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Texstyle

public struct PermissionAppearance {
    public var titleStyle: TextStyle
    public var subtitleStyle: TextStyle
    public var buttonStyle: TextStyle
    public var buttonBackgroundColor: UIColor
    public var buttonCornerRadius: Double
    public var backgroundColor: UIColor

    public init(titleStyle: TextStyle = .title2A,
                subtitleStyle: TextStyle = .body1A,
                buttonStyle: TextStyle = .title4B,
                buttonBackgroundColor: UIColor = .button1A,
                buttonCornerRadius: Double = 10,
                backgroundColor: UIColor = .white) {
        self.titleStyle = titleStyle
        self.subtitleStyle = subtitleStyle
        self.buttonStyle = buttonStyle
        self.buttonBackgroundColor = buttonBackgroundColor
        self.buttonCornerRadius = buttonCornerRadius
        self.backgroundColor = backgroundColor
    }
}
