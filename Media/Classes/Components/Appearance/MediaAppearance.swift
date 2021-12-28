//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct MediaAppearance {
    public var library: CollectionViewAppearance
    public var albums: CollectionViewAppearance
    public var list: CollectionViewAppearance

    public init(library: CollectionViewAppearance = .init(), albums: CollectionViewAppearance = .init(), list: CollectionViewAppearance = .init()) {
        self.library = library
        self.albums = albums
        self.list = list
    }
}
