//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct MediaAppearance {
    public var gallery: CollectionViewAppearance
    public var navigation: NavigationAppearance
    public var permission: PlaceholderAppearance
    public var placeholder: PlaceholderAppearance

    public init(gallery: CollectionViewAppearance = .init(),
                navigation: NavigationAppearance = .init(),
                permission: PlaceholderAppearance = DefaultPermissionsAppearance(bundleName: "App"),
                placeholder: PlaceholderAppearance = DefaultPlaceholderAppearance()) {
        self.gallery = gallery
        self.navigation = navigation
        self.permission = permission
        self.placeholder = placeholder
    }
}
