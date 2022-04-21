//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct MediaAppearance {
    public var gallery: CollectionViewAppearance
    public var navigation: NavigationAppearance
    public var permission: PermissionAppearance

    public init(gallery: CollectionViewAppearance = .init(),
                navigation: NavigationAppearance = .init(),
                permission: PermissionAppearance = .init()) {
        self.gallery = gallery
        self.navigation = navigation
        self.permission = permission
    }
}
