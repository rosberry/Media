//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import UIKit
import Photos
import CollectionViewTools
import MediaService

public final class MediaItemsPresenter {

    public enum FocusDirection {
        case up
        case down
    }

    typealias Dependencies = HasMediaLibraryService

    private let dependencies: Dependencies
    weak var view: MediaItemsViewController?

    weak var output: MediaItemsModuleOutput?

    public var collection: MediaItemsCollection? {
        didSet {
            updateMediaItemList(usingPlaceholderTransition: collection !== oldValue)
        }
    }

    public var filter: MediaItemsFilter = .all {
        didSet {
            updateMediaItemList(usingPlaceholderTransition: true)
        }
    }

    public var fetchResult: MediaItemsFetchResult?
    public var selectedItems: [MediaItem] = [] {
        didSet {
            updateSelection()
        }
    }

    private var focusDirection: FocusDirection = .down

    private lazy var mediaItemsCollector: Collector<MediaItemsFetchResult> = {
        return .init(source: dependencies.mediaLibraryService.mediaItemsEventSource)
    }()

    private lazy var mediaLibraryUpdateEventCollector: Collector<PHChange> = {
        return .init(source: dependencies.mediaLibraryService.mediaLibraryUpdateEventSource)
    }()

    private lazy var factory: MediaLibraryItemSectionsFactory = {
        let factory = MediaLibraryItemSectionsFactory(numberOfItemsInRow: numberOfItemsInRow,
                                                      dependencies: Services)
        factory.output = self
        return factory
    }()

    private let maxItemsCount: Int
    public var numberOfItemsInRow: Int

    // MARK: - Lifecycle

    init(maxItemsCount: Int, numberOfItemsInRow: Int, dependencies: Dependencies) {
        self.maxItemsCount = maxItemsCount
        self.numberOfItemsInRow = numberOfItemsInRow
        self.dependencies = dependencies
    }

    func viewReadyEventTriggered() {
        filter = .all

        setupMediaItemsCollector()
        setupMediaLibraryUpdateEventCollector()
    }

    func scrollEventTriggered(direction: FocusDirection) {
        guard focusDirection != direction else {
            return
        }

        focusDirection = direction
    }

    // MARK: - Helpers

    private func setupMediaItemsCollector() {
        mediaItemsCollector.subscribe { [weak self] (result: MediaItemsFetchResult) in
            guard let self = self else {
                return
            }
            self.fetchResult = result
            self.view?.update(with: self.sectionItemsProvider(for: result.fetchResult), animated: true)
            self.output?.didFinishLoading(result.collection, isMixedContentCollection: result.filter == .all)
        }
    }

    private func setupMediaLibraryUpdateEventCollector() {
        mediaLibraryUpdateEventCollector.subscribe { [weak self] _ in
            if let filter = self?.filter {
                self?.dependencies.mediaLibraryService.fetchMediaItems(in: self?.collection, filter: filter)
            }
        }
    }

    private func sectionItemsProvider(for result: PHFetchResult<PHAsset>) -> LazySectionItemsProvider {
        let minimumLineSpacing: CGFloat = 8.0
        let minimumInteritemSpacing: CGFloat = 8.0
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let count = result.count

        let provider = LazySectionItemsProvider(factory: factory.complexFactory) { _ in
            count
        } makeSectionItemHandler: { _ in
            let sectionItem = GeneralCollectionViewDiffSectionItem()
            sectionItem.minimumLineSpacing = minimumLineSpacing
            sectionItem.minimumInteritemSpacing = minimumInteritemSpacing
            sectionItem.insets = insets
            return sectionItem
        } sizeHandler: { [weak self] _, collection in
            let numberOfItemsInRow = CGFloat(self?.numberOfItemsInRow ?? 0)
            let widthWithoutInsets: CGFloat = collection.bounds.width - insets.left - insets.right
            let width: CGFloat = (widthWithoutInsets - numberOfItemsInRow * minimumInteritemSpacing) / numberOfItemsInRow
            return CGSize(width: width, height: width)
        } objectHandler: { indexPath in
            guard indexPath.row < count else {
                return nil
            }
            let asset = result.object(at: count - indexPath.row - 1)
            let mediaItem = MediaItem(asset: asset)
            let selectionIndex = self.selectedItems.firstIndex(of: mediaItem)
            let isSelectionInfoLabelHidden = self.maxItemsCount == 1

            switch mediaItem.type {
              case .unknown:
                return EmptyItemCellModel(mediaItem: mediaItem, selectionIndex: selectionIndex)
              case .photo, .livePhoto:
                return PhotoItemCellModel(mediaItem: mediaItem,
                                          selectionIndex: selectionIndex,
                                          isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
              case .video, .sloMoVideo:
                return VideoItemCellModel(mediaItem: mediaItem,
                                          selectionIndex: selectionIndex,
                                          isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
            }
        }
        return provider
    }

    private func updateMediaItemList(usingPlaceholderTransition: Bool) {
        guard let collection = collection else {
            return
        }

        if usingPlaceholderTransition {
            view?.showMediaItemsPlaceholder(estimatedItemCount: min(collection.estimatedMediaItemsCount ?? 64, 64))
        }

        dependencies.mediaLibraryService.fetchMediaItems(in: collection, filter: filter)
    }

    func updateSelection() {
        view?.updateSelection { item -> Int? in
            selectedItems.firstIndex(of: item)
        }
    }
}

// MARK: - MediaItemSectionsFactoryOutput
extension MediaItemsPresenter: MediaItemSectionsFactoryOutput {
    func didSelect(_ item: MediaItem) {
        var selectedItems = self.selectedItems
        if let index = selectedItems.firstIndex(of: item) {
            selectedItems.remove(at: index)
        }
        else if selectedItems.count < maxItemsCount {
            selectedItems.append(item)
        }
        self.selectedItems = selectedItems
    }

    func didRequestPreviewStart(item: MediaItem, from rect: CGRect) {
        output?.didStartPreview(item: item, from: rect)
    }

    func didRequestPreviewStop(item: MediaItem) {
        output?.didStopPreview(item: item)
    }
}

// MARK: - MediaItemsModuleInput
extension MediaItemsPresenter: MediaItemsModuleInput {

    public func update(isAuthorized: Bool) {
        if isAuthorized {
            dependencies.mediaLibraryService.fetchMediaItems(in: collection, filter: filter)
        }
        else {
            view?.showMediaLibraryDeniedPermissionsPlaceholder()
        }
    }
}
