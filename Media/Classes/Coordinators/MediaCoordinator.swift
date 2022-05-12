//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Ion
import Photos
import MediaService

public protocol MediaCoordinatorDelegate: AnyObject {
    func selectMediaItemsEventTriggered(_ mediaItems: [MediaItem])
    func photoEventTriggered(_ image: UIImage)
}

public final class MediaCoordinator {

    typealias Dependencies = HasMediaLibraryService

    private lazy var dependencies: Dependencies = Services

    let navigationViewController: UINavigationController
    public weak var delegate: MediaCoordinatorDelegate?

    private lazy var permissionsCollector: Collector<PHAuthorizationStatus> = {
        return .init(source: dependencies.mediaLibraryService.permissionStatusEventSource)
    }()

    public var maxItemsCount: Int = 2
    public var numberOfItemsInRow: Int = 4

    public var mediaAppearance: MediaAppearance
    public var filter: MediaItemsFilter
    public var needCloseBySelect: Bool = true

    // MARK: - Modules

    private var galleryModule: GalleryModule?

    // MARK: - Lifecycle

    public init(navigationViewController: UINavigationController, mediaAppearance: MediaAppearance, filter: MediaItemsFilter = .all) {
        self.navigationViewController = navigationViewController
        self.mediaAppearance = mediaAppearance
        self.filter = filter
        setupPermissionsCollector()
    }

    public init(navigationViewController: UINavigationController, filter: MediaItemsFilter = .all) {
        self.navigationViewController = navigationViewController
        self.mediaAppearance = .init()
        self.filter = filter
        setupPermissionsCollector()
    }

    public func start(bundleName: String) {
        let module = makeGalleryModule(bundleName: bundleName)
        galleryModule = module
        navigationViewController.pushViewController(module.viewController, animated: true)
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
    }

    // MARK: - Private

    private func setupPermissionsCollector() {
        permissionsCollector.subscribe { [weak self] status in
            self?.galleryModule?.input.update(isAuthorized: status == .authorized)
        }
    }

    private func makeGalleryModule(bundleName: String) -> GalleryModule {
        let module = GalleryModule(bundleName: bundleName,
                                   filter: filter,
                                   maxItemsCount: maxItemsCount,
                                   numberOfItemsInRow: numberOfItemsInRow,
                                   mediaAppearance: mediaAppearance)
        module.output = self
        return module
    }

    private func makeMediaItemPreviewModule() -> MediaItemPreviewModule {
        let module = MediaItemPreviewModule()
        module.viewController.modalPresentationStyle = .overCurrentContext
        module.viewController.modalTransitionStyle = .crossDissolve
        module.viewController.modalPresentationCapturesStatusBarAppearance = false
        return module
    }
}

// MARK: - MediaItemsModuleOutput
extension MediaCoordinator: GalleryModuleOutput {
    public func didStartPreview(item: MediaItem, from rect: CGRect) {
        let module = makeMediaItemPreviewModule()
        module.input.mediaItem = item
        navigationViewController.present(module.viewController, animated: true, completion: nil)
    }

    public func didStopPreview(item: MediaItem) {
        navigationViewController.dismiss(animated: true, completion: nil)
    }

    public func didFinishLoading(_ collection: MediaItemsCollection, isMixedContentCollection: Bool) {

    }

    public func closeEventTriggered() {
        navigationViewController.popViewController(animated: true)
    }

    public func selectMediaItemsEventTriggered(_ mediaItems: [MediaItem]) {
        if needCloseBySelect {
            navigationViewController.popViewController(animated: true)
        }
        delegate?.selectMediaItemsEventTriggered(mediaItems)
    }

    public func photoEventTriggered(_ image: UIImage) {
        if needCloseBySelect {
            navigationViewController.popViewController(animated: true)
        }
        delegate?.photoEventTriggered(image)
    }
}
