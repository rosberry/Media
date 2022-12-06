//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation
import CollectionViewTools
import MediaService
import Photos
import UIKit

protocol GallerySectionsFactoryOutput: AnyObject {
    func didSelect(_ item: MediaItem)
    func didSelect(_ collection: MediaItemsCollection)

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect)
    func didRequestPreviewStop(item: MediaItem)
}

final class GallerySectionsFactory {

    typealias Dependencies = HasMediaLibraryService

    private enum Kind {
        case video
        case photo
    }

    private var albumCellAppearance: AlbumCellAppearance = DefaultAlbumCellAppearance()
    private var assetCellAppearance: AssetCellAppearance = .init()
    private var albumSectionAppearance: AlbumSectionAppearance = .init()
    private var assetSectionAppearance: AssetSectionAppearance = .init()

    weak var output: GallerySectionsFactoryOutput?
    private let mediaAppearance: MediaAppearance
    private let dependencies: Dependencies
    private let thumbnailSize: CGSize = .init(width: 100.0, height: 100.0)

    init(dependencies: Dependencies, mediaAppearance: MediaAppearance) {
        self.dependencies = dependencies
        self.mediaAppearance = mediaAppearance
        self.albumCellAppearance = mediaAppearance.gallery.albumCellAppearance
        self.assetCellAppearance = mediaAppearance.gallery.assetCellAppearance
        self.albumSectionAppearance = mediaAppearance.gallery.albumSectionAppearance
        self.assetSectionAppearance = mediaAppearance.gallery.assetSectionAppearance
    }

    private(set) lazy var complexFactory: ComplexCellItemsFactory = {
        let complexFactory = ComplexCellItemsFactory()
        complexFactory.factory(byJoining: photoCellItemsFactory)
        complexFactory.factory(byJoining: placeholderCellItemsFactory)
        complexFactory.factory(byJoining: videoCellItemFactory)
        return complexFactory
    }()

    private(set) lazy var placeholderCellItemsFactory: CellItemsFactory<EmptyItemCellModel, PlaceholderCell> = {
        let factory = CellItemsFactory<EmptyItemCellModel, PlaceholderCell>()
        factory.cellItemConfigurationHandler = { [weak self] cellItem in
            cellItem.itemDidSelectHandler = { _ in
                self?.output?.didSelect(cellItem.object.mediaItem)
            }
        }
        return factory
    }()

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

    // MARK: - Placeholders

    func placeholderSectionItems(placeholderCount: Int) -> [CollectionViewSectionItem] {
        [makeSectionItem(cellItems: makePlaceholderCellItems(count: placeholderCount))]
    }

    func makeSectionItems(mediaItemCollections: [MediaItemsCollection]) -> [CollectionViewSectionItem] {
        let sectionItem = GeneralCollectionViewSectionItem(cellItems: makeCellItems(mediaItemCollections: mediaItemCollections))
        sectionItem.minimumLineSpacing = albumSectionAppearance.minimumLineSpacing
        sectionItem.minimumInteritemSpacing = albumSectionAppearance.minimumInteritemSpacing
        sectionItem.insets = albumSectionAppearance.insets
        return [sectionItem]
    }

    // MARK: - Private

    private func makeCellItems(mediaItemCollections: [MediaItemsCollection]) -> [CollectionViewCellItem] {
        mediaItemCollections.map(makeCellItem)
    }

    private func makeCellItem(mediaItemCollection: MediaItemsCollection) -> CollectionViewCellItem {
        let cellItem = CollectionCellItem(viewModel: mediaItemCollection,
                                          dependencies: Services,
                                          cellAppearance: albumCellAppearance,
                                          sectionAppearance: albumSectionAppearance)
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

            let size = CGSize(width: cell.bounds.width * UIScreen.main.scale,
                              height: cell.bounds.height * UIScreen.main.scale)
            self.dependencies.mediaLibraryService.fetchThumbnail(for: cellItem.object.mediaItem,
                                                                 size: size,
                                                                 contentMode: .aspectFill) { [weak self] _ in
                guard let self = self,
                    cell.modelIdentifier == cellItem.object.diffIdentifier else {
                    return
                }

                cell.update(with: cellItem.object, cellAppearance: self.assetCellAppearance)
            }

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
        sectionItem.minimumLineSpacing = assetSectionAppearance.minimumLineSpacing
        sectionItem.minimumInteritemSpacing = assetSectionAppearance.minimumInteritemSpacing
        sectionItem.insets = assetSectionAppearance.insets
        return sectionItem
    }

    private func makePlaceholderCellItems(count: Int) -> [CollectionViewCellItem] {
        return (0..<count).map { _ in
            let cellItem = PlaceholderCellItem(appearance: assetCellAppearance, sectionAppearance: assetSectionAppearance)
            return cellItem
        }
    }
}
