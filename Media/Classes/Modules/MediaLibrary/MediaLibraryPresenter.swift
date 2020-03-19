//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

typealias MediaLibraryDependencies = HasMediaLibraryService

final class MediaLibraryPresenter {

    private let dependencies: MediaLibraryDependencies
    weak var view: MediaLibraryViewController?

    weak var output: MediaLibraryModuleOutput?

    var mediaLibraryCollections: [MediaItemCollection] = []
    var activeCollection: MediaItemCollection? {
        didSet {
            updateMediaItemList()
        }
    }

    private lazy var mediaLibraryCollectionsCollector: Collector<[MediaItemCollection]> = {
        return .init(source: dependencies.mediaLibraryService.collectionsEventSource)
    }()

    private let maxItemsCount: Int

    // MARK: - Submodules

    let mediaItemCollectionsModule: MediaItemCollectionsModule
    let mediaLibraryItemsModule: MediaLibraryItemsModule

    // MARK: - Lifecycle

    init(maxItemsCount: Int,
         dependencies: MediaLibraryDependencies,
         mediaItemCollectionsModule: MediaItemCollectionsModule,
         mediaLibraryItemsModule: MediaLibraryItemsModule) {
        self.maxItemsCount = maxItemsCount
        self.dependencies = dependencies
        self.mediaItemCollectionsModule = mediaItemCollectionsModule
        self.mediaLibraryItemsModule = mediaLibraryItemsModule
    }

    func viewReadyEventTriggered() {
        setupCollectionsCollector()
    }

    func albumPickerUpdateEventTriggered() {
        mediaItemCollectionsModule.input.updateAlbumList()
    }

    func filterVideosEventTriggered() {
        mediaLibraryItemsModule.input.filter = .video
    }

    func filterAllEventTriggered() {
        mediaLibraryItemsModule.input.filter = .all
    }

    func confirmationEventTriggered() {
        var selectedItems = mediaLibraryItemsModule.input.selectedItems
        if let fetchResult = mediaLibraryItemsModule.input.fetchResult?.fetchResult {
            let mediaItems: [MediaItem] = (0..<fetchResult.count).map { index -> MediaItem in
                let asset = fetchResult.object(at: index)
                return MediaItem(asset: asset)
            }
            selectedItems = selectedItems.filter { mediaItem -> Bool in
                mediaItems.contains(mediaItem)
            }
        }
        output?.mediaLibraryModuleDidFinish(self, with: selectedItems)
    }

    // MARK: - Helpers

    private func setupCollectionsCollector() {
        mediaLibraryCollectionsCollector.subscribe { [weak self] (collections: [MediaItemCollection]) in
            self?.mediaLibraryCollections = collections
            guard self?.activeCollection == nil else {
                return
            }
            self?.activeCollection = collections.first
        }
    }

    private func updateMediaItemList() {
        guard let collection = activeCollection else {
            return
        }

        view?.setup(with: collection, filter: mediaLibraryItemsModule.input.filter)
        mediaLibraryItemsModule.input.collection = collection
    }
}

// MARK: - MediaLibraryModuleInput

extension MediaLibraryPresenter: MediaLibraryModuleInput {

    func update(isAuthorized: Bool) {
        view?.isAuthorized = isAuthorized
        if isAuthorized {
            dependencies.mediaLibraryService.fetchMediaItemCollections()
        }
    }

    func select(_ collection: MediaItemCollection) {
        view?.updateAlbumPicker(isVisible: false)
        activeCollection = collection
    }
}
