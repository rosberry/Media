//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools

protocol MediaItemCollectionSectionsFactoryOutput: AnyObject {

    func didSelect(_ collection: MediaItemCollection)
}

final class MediaItemCollectionSectionsFactory {

    weak var output: MediaItemCollectionSectionsFactoryOutput?

    func makeSectionItems(mediaItemCollections: [MediaItemCollection]) -> [CollectionViewSectionItem] {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: makeCellItems(mediaItemCollections: mediaItemCollections))
        return [sectionItem]
    }

    // MARK: - Private

    private func makeCellItems(mediaItemCollections: [MediaItemCollection]) -> [CollectionViewCellItem] {
        mediaItemCollections.map(makeCellItem)
    }

    private func makeCellItem(mediaItemCollection: MediaItemCollection) -> CollectionViewCellItem {
        let cellItem = MediaItemCollectionCellItem(viewModel: mediaItemCollection, dependencies: Services)
        cellItem.itemDidSelectHandler = { [weak self] in
            self?.output?.didSelect(mediaItemCollection)
        }
        return cellItem
    }
}
