//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation
import Texstyle

public struct ManagerAppearance {
    var title: String
    var titleStyle: TextStyle
    var buttonTitle: String
    var buttonTitleStyle: TextStyle
    var cornerRadius: Double
    var backgroundColor: UIColor

    public init(projectName: String = "Gallery",
                title: String? = nil,
                titleStyle: TextStyle = .body1C,
                buttonTitle: String? = nil,
                buttonTitleStyle: TextStyle = .button1A,
                cornerRadius: Double = 15,
                backgroundColor: UIColor = .button1A) {
        self.titleStyle = titleStyle
        self.buttonTitleStyle = buttonTitleStyle
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.buttonTitle = buttonTitle ?? L10n.ManageAccess.buttonTitle
        self.title = title ?? L10n.ManageAccess.title(projectName, self.buttonTitle)
    }
}
