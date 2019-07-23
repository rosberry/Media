//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools

protocol MediaLibraryItemListCellItemFactoryOutput: AnyObject {
    func didSelect(item: MediaItem)

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect)
    func didRequestPreviewStop(item: MediaItem)
}

final class MediaLibraryItemListCellItemFactory {
    weak var output: MediaLibraryItemListCellItemFactoryOutput?

    // MARK: - Media Items

    func cellItem(for mediaItem: MediaItem,
                  selectionIndex: Int?,
                  isSelectionInfoLabelHidden: Bool) -> CollectionViewCellItem {
        let cellModel = MediaLibraryBaseMediaItemCellModel(mediaItem: mediaItem, selectionIndex: selectionIndex)

        let cellItem: CollectionViewCellItem
        switch mediaItem.type {
        case .unknown:
            cellItem = MediaLibraryPlaceholderCellItem()
        case .photo, .livePhoto:
            cellItem = MediaLibraryPhotoMediaItemCellItem(viewModel: cellModel,
                                                          dependencies: Services.sharedScope,
                                                          isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
        case .video, .sloMoVideo:
            cellItem = MediaLibraryVideoMediaItemCellItem(viewModel: cellModel,
                                                          dependencies: Services.sharedScope,
                                                          isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
        }

        cellItem.itemDidSelectHandler = { [weak self] in
            self?.output?.didSelect(item: mediaItem)
        }

        if let mediaCellItem = cellItem as? MediaLibraryBaseMediaItemCellItem {
            mediaCellItem.previewStartHandler = { [weak self] (_, rect: CGRect) in
                self?.output?.didRequestPreviewStart(item: mediaItem, from: rect)
            }

            mediaCellItem.previewStopHandler = { [weak self] _ in
                self?.output?.didRequestPreviewStop(item: mediaItem)
            }
        }

        return cellItem
    }

    // MARK: - Placeholders

    func placeholderSectionItems(placeholderCount: Int) -> [CollectionViewSectionItem] {
        return [sectionItem(for: placeholderCellItems(count: placeholderCount))]
    }

    private func placeholderCellItems(count: Int) -> [CollectionViewCellItem] {
        guard count > 0 else {
            return []
        }

        return (0..<count).lazy.map { (_) -> CollectionViewCellItem in
            return MediaLibraryPlaceholderCellItem()
        }
    }

    // MARK: - Sections

    private func sectionItem(for cellItems: [CollectionViewCellItem]) -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: cellItems, reusableViewItems: [])
        sectionItem.minimumLineSpacing = 8.0
        sectionItem.minimumInteritemSpacing = 8.0
        sectionItem.insets = .init(top: 8, left: 8, bottom: 8, right: 8)
        return sectionItem
    }
}
