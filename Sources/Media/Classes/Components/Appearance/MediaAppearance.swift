//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct MediaAppearance {
    public var gallery: CollectionViewAppearance
    public var navigation: NavigationAppearance
    public var permission: PlaceholderAppearance
    public var accessManager: ManagerAppearance
    public var placeholder: PlaceholderAppearance
    public var actionSheet: ActionSheetAppearance

    public init(gallery: CollectionViewAppearance = .init(),
                navigation: NavigationAppearance = .init(),
                permission: PlaceholderAppearance = DefaultPermissionsAppearance(),
                accessManager: ManagerAppearance = .init(),
                placeholder: PlaceholderAppearance = DefaultPlaceholderAppearance(),
                actionSheet: ActionSheetAppearance = .init()) {
        self.gallery = gallery
        self.navigation = navigation
        self.permission = permission
        self.accessManager = accessManager
        self.placeholder = placeholder
        self.actionSheet = actionSheet
    }
}
