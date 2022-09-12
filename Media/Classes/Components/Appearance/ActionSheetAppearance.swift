//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation
import UIKit

public struct ActionSheetAppearance {
    var backgroundColor: UIColor

    var containerButtonsColor: UIColor
    var containerButtonsCornerRadius: Double

    var cancelButtonAppearance: ActionButtonAppearance
    var actionButtonsAppearance: [ActionButtonAppearance]

    public init(backgroundColor: UIColor = .main1A,
                containerButtonsColor: UIColor = .main2A,
                containerButtonsCornerRadius: Double = 14,
                cancelButtonAppearance: ActionButtonAppearance? = nil,
                actionButtonsAppearance: [ActionButtonAppearance] = []) {
        self.backgroundColor = backgroundColor
        self.containerButtonsColor = containerButtonsColor
        self.containerButtonsCornerRadius = containerButtonsCornerRadius
        self.cancelButtonAppearance = cancelButtonAppearance ?? .init(title: L10n.ManageAccess.cancel,
                                                                      lineColor: nil,
                                                                      backgroundColor: .main2A)

        guard actionButtonsAppearance.isEmpty else {
            self.actionButtonsAppearance = actionButtonsAppearance
            return
        }

        self.actionButtonsAppearance = [
            ActionButtonAppearance(type: .more, title: L10n.ManageAccess.more),
            ActionButtonAppearance(type: .setting, title: L10n.ManageAccess.settings)
        ]
    }
}
