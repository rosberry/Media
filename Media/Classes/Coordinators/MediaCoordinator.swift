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

    lazy var module = MediaLibraryModule(maxItemsCount: 2)

    // MARK: - Lifecycle

    public init(navigationViewController: UINavigationController) {
        self.navigationViewController = navigationViewController
    }

    public func start() {
        dependencies.mediaLibraryService.requestMediaLibraryPermissions()
        navigationViewController.pushViewController(module.viewController, animated: true)
    }
}
