//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation
import Texstyle

public struct ManagerAppearance {
    let projectName: String
    let title: String
    let titleStyle: TextStyle
    let buttonTitle: String
    let buttonTitleStyle: TextStyle
    let cornerRadius: Double
    let backgroundColor: UIColor

    public init(projectName: String = "Gallery",
                title: String? = nil,
                titleStyle: TextStyle = .body1C,
                buttonTitle: String? = nil,
                buttonTitleStyle: TextStyle = .button1A,
                cornerRadius: Double = 15,
                backgroundColor: UIColor = .button1A) {
        self.projectName = projectName
        self.titleStyle = titleStyle
        self.buttonTitleStyle = buttonTitleStyle
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor

        if buttonTitle == nil {
            self.buttonTitle = L10n.ManageAccess.buttonTitle
        }
        else {
            self.buttonTitle = buttonTitle ?? ""
        }

        if title == nil {
            self.title = L10n.ManageAccess.title(projectName, self.buttonTitle)
        }
        else {
            self.title = title ?? ""
        }
    }
}
