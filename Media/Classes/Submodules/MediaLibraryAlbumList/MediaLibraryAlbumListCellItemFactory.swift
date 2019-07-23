//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools

protocol MediaLibraryAlbumListCellItemFactoryOutput: AnyObject {
    func didSelect(collection: MediaItemCollection)
}

final class MediaLibraryAlbumListCellItemFactory {
    weak var output: MediaLibraryAlbumListCellItemFactoryOutput?

    func sectionItems(for mediaItemCollections: [MediaItemCollection]) -> [CollectionViewSectionItem] {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: cellItems(for: mediaItemCollections), reusableViewItems: [])
        return [sectionItem]
    }

    func cellItems(for mediaItemCollections: [MediaItemCollection]) -> [CollectionViewCellItem] {
        return mediaItemCollections.map({ (collection: MediaItemCollection) -> CollectionViewCellItem in
            return self.cellItem(for: collection)
        })
    }

    func cellItem(for mediaItemCollection: MediaItemCollection) -> CollectionViewCellItem {
        let cellItem = MediaLibraryAlbumListCellItem(viewModel: mediaItemCollection, dependencies: Services.sharedScope)
        cellItem.itemDidSelectHandler = { [weak self] in
            self?.output?.didSelect(collection: mediaItemCollection)
        }

        return cellItem
    }
}
