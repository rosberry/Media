//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools
import MediaService

protocol CollectionSectionsFactoryOutput: AnyObject {

    func didSelect(_ collection: MediaItemsCollection)
}

final class CollectionSectionsFactory {

    weak var output: CollectionSectionsFactoryOutput?
    var cellAppearance: CellAppearance = .init()

    func makeSectionItems(mediaItemCollections: [MediaItemsCollection]) -> [CollectionViewSectionItem] {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: makeCellItems(mediaItemCollections: mediaItemCollections))
        return [sectionItem]
    }

    // MARK: - Private

    private func makeCellItems(mediaItemCollections: [MediaItemsCollection]) -> [CollectionViewCellItem] {
        mediaItemCollections.map(makeCellItem)
    }

    private func makeCellItem(mediaItemCollection: MediaItemsCollection) -> CollectionViewCellItem {
        let cellItem = CollectionCellItem(viewModel: mediaItemCollection, dependencies: Services, cellAppearance: cellAppearance)
        cellItem.itemDidSelectHandler = { [weak self] _ in
            self?.output?.didSelect(mediaItemCollection)
        }
        return cellItem
    }
}
