//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

final class CollectionsPresenter {

    typealias Dependencies = HasMediaLibraryService

    private let dependencies: Dependencies
    weak var view: CollectionsController?

    weak var output: CollectionsModuleOutput?

    var collections: [MediaItemCollection] = []

    private lazy var collectionsCollector: Collector<[MediaItemCollection]> = {
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
        collectionsCollector.subscribe { (collections: [MediaItemCollection]) in
            self.collections = collections
            self.view?.update(with: collections)
        }
    }

    private func setupMediaLibraryUpdateEventCollector() {
        mediaLibraryUpdateEventCollector.subscribe { [weak self] _ in
            self?.updateCollections()
        }
    }
}

// MARK: - MediaItemCollectionSectionsFactoryOutput

extension CollectionsPresenter: CollectionSectionsFactoryOutput {

    func didSelect(_ collection: MediaItemCollection) {
        output?.didSelect(collection)
    }
}

// MARK: - MediaItemCollectionsModuleInput

extension CollectionsPresenter: CollectionsModuleInput {

    func update(isAuthorized: Bool) {
        if isAuthorized {
            updateCollections()
        }
        else {
            view?.showMediaLibraryDeniedPermissionsPlaceholder()
        }
    }

    func updateCollections() {
        dependencies.mediaLibraryService.fetchMediaItemCollections()
    }
}
