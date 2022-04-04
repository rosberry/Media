//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools
import MediaService
import Photos

protocol GallerySectionsFactoryOutput: AnyObject {
    func didSelect(_ item: MediaItem)
    func didSelect(_ collection: MediaItemsCollection)

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect)
    func didRequestPreviewStop(item: MediaItem)
}

final class GallerySectionsFactory {

    typealias Dependencies = HasMediaLibraryService
    
    var cellAppearance: CellAppearance = .init()

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
        configureFactory(factory: factory)
        return factory
    }()

    private(set) lazy var videoCellItemFactory: CellItemsFactory<VideoItemCellModel, VideoMediaItemCell> = {
        let factory = CellItemsFactory<VideoItemCellModel, VideoMediaItemCell>()
        configureFactory(factory: factory)
        return factory
    }()

    weak var output: GallerySectionsFactoryOutput?

    let numberOfItemsInRow: Int
    private let collectionAppearance: CollectionViewAppearance
    private let dependencies: Dependencies
    private let thumbnailSize: CGSize = .init(width: 100.0, height: 100.0)

    init(numberOfItemsInRow: Int, dependencies: Dependencies, collectionAppearance: CollectionViewAppearance) {
        self.numberOfItemsInRow = numberOfItemsInRow
        self.dependencies = dependencies
        self.collectionAppearance = collectionAppearance
    }

    // MARK: - Placeholders

    func placeholderSectionItems(placeholderCount: Int) -> [CollectionViewSectionItem] {
        [makeSectionItem(cellItems: makePlaceholderCellItems(count: placeholderCount))]
    }

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

    private func configureFactory<Object: EmptyItemCellModel, Cell: MediaItemCell>(factory: CellItemsFactory<Object, Cell>) {
        factory.cellConfigurationHandler = { [weak self] cell, cellItem in
            guard let self = self else {
                return
            }

            cell.modelIdentifier = cellItem.object.diffIdentifier

            self.dependencies.mediaLibraryService.fetchThumbnail(for: cellItem.object.mediaItem,
                                                                 size: self.thumbnailSize,
                                                                 contentMode: .aspectFill) { [weak self] _ in
                guard let self = self,
                    cell.modelIdentifier == cellItem.object.diffIdentifier else {
                    return
                }

                cell.update(with: cellItem.object, cellAppearance: self.collectionAppearance.cellAppearance)
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
    }

    private func makeSectionItem(cellItems: [CollectionViewCellItem]) -> CollectionViewSectionItem {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: cellItems)
        sectionItem.minimumLineSpacing = collectionAppearance.sectionAppearance.minimumLineSpacing
        sectionItem.minimumInteritemSpacing = collectionAppearance.sectionAppearance.minimumInteritemSpacing
        sectionItem.insets = collectionAppearance.sectionAppearance.insets
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
