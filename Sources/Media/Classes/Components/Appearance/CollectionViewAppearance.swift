//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

public struct CollectionViewAppearance {
    public var backgroundColor: UIColor
    public var collectionViewBackgroundColor: UIColor
    public var albumCellAppearance: AlbumCellAppearance
    public var albumSectionAppearance: AlbumSectionAppearance
    public var assetCellAppearance: AssetCellAppearance
    public var assetSectionAppearance: AssetSectionAppearance

    public init(backgroundColor: UIColor = .white,
                collectionViewBackgroundColor: UIColor = .white,
                albumCellAppearance: AlbumCellAppearance = .init(),
                albumSectionAppearance: AlbumSectionAppearance = .init(),
                assetCellAppearance: AssetCellAppearance = .init(),
                assetSectionAppearance: AssetSectionAppearance = .init()) {
        self.backgroundColor = backgroundColor
        self.collectionViewBackgroundColor = collectionViewBackgroundColor
        self.albumCellAppearance = albumCellAppearance
        self.albumSectionAppearance = albumSectionAppearance
        self.assetCellAppearance = assetCellAppearance
        self.assetSectionAppearance = assetSectionAppearance
    }
}
