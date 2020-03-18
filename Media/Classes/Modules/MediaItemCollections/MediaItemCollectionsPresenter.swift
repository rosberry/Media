//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

final class MediaItemCollectionsPresenter {

    typealias Dependencies = HasMediaLibraryService

    private let dependencies: Dependencies
    weak var view: MediaItemCollectionsController?

    weak var output: MediaItemCollectionsModuleOutput?

    var collections: [MediaItemCollection] = []

    private lazy var mediaLibraryCollectionsCollector: Collector<[MediaItemCollection]> = {
        return .init(source: dependencies.mediaLibraryService.collectionsEventSource)
    }()

    private lazy var mediaLibraryUpdateEventCollector: Collector<PHChange> = {
        return .init(source: dependencies.mediaLibraryService.mediaLibraryUpdateEventSource)
    }()

    // MARK: - Lifecycle

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func viewReadyEventTriggered() {
        setupCollectionsCollector()
        setupMediaLibraryUpdateEventCollector()
    }

    // MARK: - Helpers

    private func setupCollectionsCollector() {
        mediaLibraryCollectionsCollector.subscribe { (collections: [MediaItemCollection]) in
            self.collections = collections
            self.view?.update(with: collections)
        }
    }

    private func setupMediaLibraryUpdateEventCollector() {
        mediaLibraryUpdateEventCollector.subscribe { [weak self] _ in
            self?.updateAlbumList()
        }
    }
}

// MARK: - MediaItemCollectionSectionsFactoryOutput

extension MediaItemCollectionsPresenter: MediaItemCollectionSectionsFactoryOutput {

    func didSelect(_ collection: MediaItemCollection) {
        output?.didSelect(collection)
    }
}

// MARK: - MediaItemCollectionsModuleInput

extension MediaItemCollectionsPresenter: MediaItemCollectionsModuleInput {

    func update(isAuthorized: Bool) {
        if isAuthorized {
            updateAlbumList()
        }
        else {
            view?.showMediaLibraryDeniedPermissionsPlaceholder()
        }
    }

    func updateAlbumList() {
        dependencies.mediaLibraryService.fetchMediaItemCollections()
    }
}
