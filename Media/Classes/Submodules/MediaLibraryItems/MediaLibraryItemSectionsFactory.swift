//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools

protocol MediaLibraryItemSectionsFactoryOutput: AnyObject {
    func didSelect(_ item: MediaItem)

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect)
    func didRequestPreviewStop(item: MediaItem)
}

final class MediaLibraryItemSectionsFactory {

    weak var output: MediaLibraryItemSectionsFactoryOutput?

    var numberOfItemsInRow: Int = 4

    // MARK: - Media Items

    func makeCellItem(mediaItem: MediaItem,
                      selectionIndex: Int?,
                      isSelectionInfoLabelHidden: Bool) -> CollectionViewCellItem {
        let cellModel = MediaItemCellModel(mediaItem: mediaItem, selectionIndex: selectionIndex)

        let cellItem: CollectionViewCellItem
        switch mediaItem.type {
            case .unknown:
                cellItem = PlaceholderCellItem()
            case .photo, .livePhoto:
                let item = PhotoMediaItemCellItem(viewModel: cellModel,
                                                  dependencies: Services,
                                                  isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
                item.numberOfItemsInRow = numberOfItemsInRow
                cellItem = item
            case .video, .sloMoVideo:
                let item = VideoMediaItemCellItem(viewModel: cellModel,
                                                  dependencies: Services,
                                                  isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
                item.numberOfItemsInRow = numberOfItemsInRow
                cellItem = item
        }

        cellItem.itemDidSelectHandler = { [weak self] in
            self?.output?.didSelect(mediaItem)
        }

        if let mediaCellItem = cellItem as? MediaItemCellItem {
            mediaCellItem.previewStartHandler = { [weak output] (_, rect: CGRect) in
                output?.didRequestPreviewStart(item: mediaItem, from: rect)
            }

            mediaCellItem.previewStopHandler = { [weak output] _ in
                output?.didRequestPreviewStop(item: mediaItem)
            }
        }

        return cellItem
    }

    // MARK: - Placeholders

    func placeholderSectionItems(placeholderCount: Int) -> [CollectionViewSectionItem] {
        [makeSectionItem(cellItems: makePlaceholderCellItems(count: placeholderCount))]
    }

    private func makeSectionItem(cellItems: [CollectionViewCellItem]) -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: cellItems)
        sectionItem.minimumLineSpacing = 8
        sectionItem.minimumInteritemSpacing = 8
        sectionItem.insets = .init(top: 8, left: 8, bottom: 8, right: 8)
        return sectionItem
    }

    private func makePlaceholderCellItems(count: Int) -> [CollectionViewCellItem] {
        return (0..<count).map { _ in
            let cellItem = PlaceholderCellItem()
            cellItem.numberOfItemsInRow = numberOfItemsInRow
            return cellItem
        }
    }
}
