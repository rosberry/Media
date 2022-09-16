//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct MediaAppearance {
    public var gallery: CollectionViewAppearance
    public var navigation: NavigationAppearance
    public var permission: PermissionAppearance
    public var accessManager: AccessManagerAppearance
    public var actionSheet: ActionSheetAppearance

    public init(gallery: CollectionViewAppearance = .init(),
                navigation: NavigationAppearance = .init(),
                permission: PermissionAppearance = .init(),
                accessManager: AccessManagerAppearance = .init(),
                actionSheet: ActionSheetAppearance = .init()) {
        self.gallery = gallery
        self.navigation = navigation
        self.permission = permission
        self.accessManager = accessManager
        self.actionSheet = actionSheet
    }
}
