//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Ion
import Photos

public final class MediaCoordinator {

     public enum Context {
        case library
        case albums
        case items
    }

    typealias Dependencies = HasMediaLibraryService

    private lazy var dependencies: Dependencies = Services

    let navigationViewController: UINavigationController

    private lazy var permissionsCollector: Collector<PHAuthorizationStatus> = {
        return .init(source: dependencies.mediaLibraryService.permissionStatusEventSource)
    }()

    public var maxItemsCount: Int = 2
    public var numberOfItemsInRow: Int = 4

    // MARK: - Modules

    lazy var mediaLibraryModule: MediaLibraryModule = {
        let module = MediaLibraryModule(maxItemsCount: maxItemsCount,
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
        let module = MediaLibraryItemsModule(maxItemsCount: maxItemsCount, numberOfItemsInRow: numberOfItemsInRow)
        module.output = self
        return module
    }()

    lazy var mediaItemPreviewModule: MediaItemPreviewModule = {
        let module = MediaItemPreviewModule()
        module.viewController.modalPresentationStyle = .overCurrentContext
        module.viewController.modalTransitionStyle = .crossDissolve
        module.viewController.modalPresentationCapturesStatusBarAppearance = false
        return module
    }()

    // MARK: - Lifecycle

    public init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
        setupPermissionsCollector()
    }

    public func start(with context: Context) {
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
        switch context {
            case .library:
                let module = makeMediaLibraryModule()
                navigationViewController.pushViewController(module.viewController, animated: true)
            case .albums:
                navigationViewController.pushViewController(mediaItemCollectionsModule.viewController, animated: true)
            case .items:
                navigationViewController.pushViewController(mediaLibraryItemsModule.viewController, animated: true)
        }
    }

    // MARK: - Private

    private func setupPermissionsCollector() {
        permissionsCollector.subscribe { [weak self] status in
            self?.mediaLibraryModule.input.update(isAuthorized: status == .authorized)
            self?.mediaItemCollectionsModule.input.update(isAuthorized: status == .authorized)
            self?.mediaLibraryItemsModule.input.update(isAuthorized: status == .authorized)
        }
    }

    private func makeMediaLibraryModule() -> MediaLibraryModule {
        let module = MediaLibraryModule(maxItemsCount: maxItemsCount,
                                        mediaItemCollectionsModule: mediaItemCollectionsModule,
                                        mediaLibraryItemsModule: mediaLibraryItemsModule)
        module.output = self
        return module
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

    public func didStartPreview(item: MediaItem, from rect: CGRect) {
        navigationViewController.present(mediaItemPreviewModule.viewController, animated: true, completion: nil)
    }

    public func didStopPreview(item: MediaItem) {
        navigationViewController.dismiss(animated: true, completion: nil)
    }

    public func didFinishLoading(_ collection: MediaItemCollection, isMixedContentCollection: Bool) {

    }
}
