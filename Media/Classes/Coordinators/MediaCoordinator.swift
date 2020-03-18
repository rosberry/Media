//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Ion
import Photos

public final class MediaCoordinator {

    typealias Dependencies = HasMediaLibraryService

    private lazy var dependencies: Dependencies = Services

    lazy var navigationViewController: UINavigationController = .init()

    private lazy var mediaLibraryPermissionsCollector: Collector<PHAuthorizationStatus> = {
        return .init(source: dependencies.mediaLibraryService.permissionStatusEventSource)
    }()

    // MARK: - Modules

    lazy var mediaLibraryModule: MediaLibraryModule = {
        let module = MediaLibraryModule(maxItemsCount: 2,
                                        mediaItemCollectionsModule: mediaItemCollectionsModule,
                                        mediaLibraryItemsModule: mediaLibraryItemsModule)
        module.output = self
        return module
    }()

    lazy var mediaItemCollectionsModule: MediaItemCollectionsModule = {
        let module = MediaItemCollectionsModule()
        module.output = self
        return module
    }()

    lazy var mediaLibraryItemsModule: MediaLibraryItemsModule = {
        let module = MediaLibraryItemsModule(maxItemsCount: 2)
        module.output = self
        return module
    }()

    // MARK: - Lifecycle

    public init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
    }

    public func start() {
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
        navigationViewController.pushViewController(mediaLibraryModule.viewController, animated: true)
    }
}

// MARK: - MediaLibraryModuleOutput
extension MediaCoordinator: MediaLibraryModuleOutput {

    public func mediaLibraryModuleDidFinish(_ moduleInput: MediaLibraryModuleInput, with items: [MediaItem]) {
        navigationViewController.popViewController(animated: true)
    }
}

// MARK: - MediaItemCollectionsModuleOutput
extension MediaCoordinator: MediaItemCollectionsModuleOutput {

    public func didSelect(_ collection: MediaItemCollection) {
        mediaLibraryModule.input.select(collection)
    }
}

// MARK: - MediaLibraryItemsModuleOutput
extension MediaCoordinator: MediaLibraryItemsModuleOutput {

    public func didFinishLoading(_ collection: MediaItemCollection, isMixedContentCollection: Bool) {

    }
}
