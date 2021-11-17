//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos
import MediaService

final class MediaLibraryPresenter {

    typealias Dependencies = HasMediaLibraryService

    private let dependencies: Dependencies
    weak var view: MediaLibraryViewController?

    weak var output: MediaLibraryModuleOutput?

    var collections: [MediaItemsCollection] = []
    var configureView: ConfigureView
    var activeCollection: MediaItemsCollection? {
        didSet {
            updateMediaItemList()
        }
    }

    private lazy var collectionsCollector: Collector<[MediaItemsCollection]> = {
        return .init(source: dependencies.mediaLibraryService.collectionsEventSource)
    }()

    private let maxItemsCount: Int

    // MARK: - Submodules

    let collectionsModule: CollectionsModule
    let mediaItemsModule: MediaItemsModule

    // MARK: - Lifecycle

    init(maxItemsCount: Int,
         dependencies: Dependencies,
         collectionsModule: CollectionsModule,
         mediaItemsModule: MediaItemsModule,
         configureView: ConfigureView) {
        self.maxItemsCount = maxItemsCount
        self.dependencies = dependencies
        self.collectionsModule = collectionsModule
        self.mediaItemsModule = mediaItemsModule
        self.configureView = configureView
    }

    func viewReadyEventTriggered() {
        setupCollectionsCollector()
    }

    func albumPickerUpdateEventTriggered() {
        collectionsModule.input.updateCollections()
    }

    func changeFilterEventTriggered(with filter: MediaItemsFilter) {
        mediaItemsModule.input.filter = filter
    }

    func confirmationEventTriggered() {
        var selectedItems = mediaItemsModule.input.selectedItems
        if let fetchResult = mediaItemsModule.input.fetchResult?.fetchResult {
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
        collectionsCollector.subscribe { [weak self] (collections: [MediaItemsCollection]) in
            self?.collections = collections
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

        view?.setup(with: collection, filter: mediaItemsModule.input.filter)
        mediaItemsModule.input.collection = collection
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

    func select(_ collection: MediaItemsCollection) {
        view?.updateCollectionPicker(isVisible: false)
        activeCollection = collection
    }
}
