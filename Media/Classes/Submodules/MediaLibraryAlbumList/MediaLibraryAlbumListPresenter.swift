//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Ion
import Photos

typealias MediaLibraryAlbumListDependencies = HasMediaLibraryService

final class MediaLibraryAlbumListPresenter {

    private let dependencies: MediaLibraryAlbumListDependencies
    weak var view: MediaLibraryAlbumListViewController?

    weak var output: MediaLibraryAlbumListModuleOutput?

    var collections: [MediaItemCollection]?

    private lazy var mediaLibraryCollectionListCollector: Collector<[MediaItemCollection]> = {
        return .init(source: dependencies.mediaLibraryService.collectionListEventSource)
    }()
    
    private lazy var mediaLibraryPermissionsCollector: Collector<PHAuthorizationStatus> = {
        return .init(source: dependencies.mediaLibraryService.permissionStatusEventSource)
    }()
    
    private lazy var mediaLibraryUpdateEventCollector: Collector<PHChange> = {
        return .init(source: dependencies.mediaLibraryService.mediaLibraryUpdateEventSource)
    }()

    // MARK: - Lifecycle

    init(dependencies: MediaLibraryAlbumListDependencies) {
        self.dependencies = dependencies
    }

    func viewReadyEventTriggered() {
        setupCollectionListCollector()
        setupPermissionsCollector()
        setupMediaLibraryUpdateEventCollector()
        
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
    }
    
    // MARK: - Helpers

    private func setupCollectionListCollector() {
        mediaLibraryCollectionListCollector.subscribe { (collections: [MediaItemCollection]) in
            self.collections = collections
            self.view?.update(with: collections)
        }
    }
    
    private func setupPermissionsCollector() {
        mediaLibraryPermissionsCollector.subscribe { (status: PHAuthorizationStatus) in
            switch status {
            case .denied:
                self.view?.showMediaLibraryDeniedPermissionsPlaceholder()
            case .authorized:
                self.updateAlbumList()
            default:
                break
            }
        }
    }
    
    private func setupMediaLibraryUpdateEventCollector() {
        mediaLibraryUpdateEventCollector.subscribe { [weak self] _ in
            self?.updateAlbumList()
        }
    }
}

// MARK: - MediaLibraryItemListCellItemFactoryOutput

extension MediaLibraryAlbumListPresenter: MediaLibraryAlbumListCellItemFactoryOutput {

    func didSelect(collection: MediaItemCollection) {
        output?.didSelect(collection: collection)
    }
}

// MARK: - MediaLibraryAlbumListModuleInput

extension MediaLibraryAlbumListPresenter: MediaLibraryAlbumListModuleInput {

    func updateAlbumList() {
        dependencies.mediaLibraryService.fetchMediaItemCollectionList()
    }
}
