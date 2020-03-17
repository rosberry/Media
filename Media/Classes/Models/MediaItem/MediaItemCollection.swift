//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Photos

public final class MediaItemCollection {

    public var identifier: String
    public var title: String?
    public var thumbnail: UIImage?
    public var mediaItems: [MediaItem]
    public var estimatedMediaItemsCount: Int?
    public var isFavorite: Bool = false

    public init(identifier: String, title: String?, mediaItems: [MediaItem] = []) {
        self.identifier = identifier
        self.title = title
        self.mediaItems = mediaItems
    }

    public func flush() {
        mediaItems.removeAll()
    }
}

public extension MediaItemCollection {

    convenience init(collection: PHAssetCollection) {
        self.init(identifier: collection.localIdentifier, title: collection.localizedTitle)
        estimatedMediaItemsCount = collection.estimatedAssetCount
    }
}

extension MediaItemCollection: CustomStringConvertible {

    public var description: String {
        return title ?? identifier
    }
}
