//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct MediaAppearance {
    public var gallery: CollectionViewAppearance
    public var navigation: NavigationAppearance
    public var permission: PlaceholderAppearance
    public var placeholder: PlaceholderAppearance
    public var managerAccess: ManagerAppearance
    public var actionSheet: ActionSheetAppearance

    public init(gallery: CollectionViewAppearance = .init(),
                navigation: NavigationAppearance = .init(),
                permission: PlaceholderAppearance = DefaultPermissionsAppearance(),
                placeholder: PlaceholderAppearance = DefaultPlaceholderAppearance(),
                managerAccess: ManagerAppearance = .init(),
                actionSheet: ActionSheetAppearance = .init()) {
        self.gallery = gallery
        self.navigation = navigation
        self.permission = permission
        self.placeholder = placeholder
        self.managerAccess = managerAccess
        self.actionSheet = actionSheet
    }
}
