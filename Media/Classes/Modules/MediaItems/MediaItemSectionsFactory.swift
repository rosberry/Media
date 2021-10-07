//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools
import MediaService
import Photos

protocol MediaItemSectionsFactoryOutput: AnyObject {
    func didSelect(_ item: MediaItem)

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect)
    func didRequestPreviewStop(item: MediaItem)
}

final class MediaLibraryItemSectionsFactory {

    typealias Dependencies = HasMediaLibraryService

    private(set) lazy var complexFactory: ComplexCellItemsFactory = {
        let complexFactory = ComplexCellItemsFactory()
        complexFactory.factory(byJoining: photoCellItemsFactory)
        complexFactory.factory(byJoining: placeholderCellItemsFactory)
        complexFactory.factory(byJoining: videoCellItemFactory)
        return complexFactory
    }()

    private(set) lazy var placeholderCellItemsFactory: CellItemsFactory<EmptyItemCellModel, UICollectionViewCell> = {
        let factory = CellItemsFactory<EmptyItemCellModel, UICollectionViewCell>()
        factory.cellItemConfigurationHandler = { [weak self] cellItem in
            cellItem.itemDidSelectHandler = { _ in
                self?.output?.didSelect(cellItem.object.mediaItem)
            }
        }
        return factory
    }()

    private enum Kind {
        case video
        case photo
    }

    private(set) lazy var photoCellItemsFactory: CellItemsFactory<PhotoItemCellModel, PhotoMediaItemCell> = {
        let factory = CellItemsFactory<PhotoItemCellModel, PhotoMediaItemCell>()
        factory.cellConfigurationHandler = { [weak self] cell, cellItem in
            guard let self = self else {
                return
            }

            self.dependencies.mediaLibraryService.fetchThumbnail(for: cellItem.object.mediaItem,
                                                                 size: self.thumbnailSize,
                                                                 contentMode: .aspectFill) { _ in
                cell.update(with: cellItem.object)
            }

            cell.selectionView.selectionInfoLabel.isHidden = cellItem.object.isSelectionInfoLabelHidden

            cell.didRequestPreviewStartHandler = { [weak self] sender in
                self?.output?.didRequestPreviewStart(item: cellItem.object.mediaItem, from: sender.frame)
            }

            cell.didRequestPreviewStopHandler = { [weak self] _ in
                self?.output?.didRequestPreviewStop(item: cellItem.object.mediaItem)
            }
        }
        factory.cellItemConfigurationHandler = { [weak self] cellItem in
            let mediaItem = cellItem.object.mediaItem
            cellItem.itemDidSelectHandler = { _ in
                self?.output?.didSelect(mediaItem)
            }
        }
        return factory
    }()

    private(set) lazy var videoCellItemFactory: CellItemsFactory<VideoItemCellModel, VideoMediaItemCell> = {
        let factory = CellItemsFactory<VideoItemCellModel, VideoMediaItemCell>()
        factory.cellConfigurationHandler = { [weak self] cell, cellItem in
            guard let self = self else {
                return
            }

            self.dependencies.mediaLibraryService.fetchThumbnail(for: cellItem.object.mediaItem,
                                                                 size: self.thumbnailSize,
                                                                 contentMode: .aspectFill) { _ in
                cell.update(with: cellItem.object)
            }

            cell.selectionView.selectionInfoLabel.isHidden = cellItem.object.isSelectionInfoLabelHidden

            cell.didRequestPreviewStartHandler = { [weak self] sender in
                self?.output?.didRequestPreviewStart(item: cellItem.object.mediaItem, from: sender.frame)
            }

            cell.didRequestPreviewStopHandler = { [weak self] _ in
                self?.output?.didRequestPreviewStop(item: cellItem.object.mediaItem)
            }
        }
        factory.cellItemConfigurationHandler = { [weak self] cellItem in

            let mediaItem = cellItem.object.mediaItem
            cellItem.itemDidSelectHandler = { _ in
                self?.output?.didSelect(mediaItem)
            }
        }
        return factory
    }()

    weak var output: MediaItemSectionsFactoryOutput?

    let numberOfItemsInRow: Int
    private let dependencies: Dependencies
    private let thumbnailSize: CGSize = .init(width: 100.0, height: 100.0)

    init(numberOfItemsInRow: Int, dependencies: Dependencies) {
        self.numberOfItemsInRow = numberOfItemsInRow
        self.dependencies = dependencies
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
