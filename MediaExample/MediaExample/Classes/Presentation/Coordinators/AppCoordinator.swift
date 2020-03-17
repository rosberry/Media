//
// Copyright (c) 2018 Rosberry. All rights reserved.
//

import UIKit
import Media

final class AppCoordinator: BaseCoordinator<UIViewController> {

    var window: UIWindow?

    init() {
        let navigationController = UINavigationController()
//        let module = MediaLibraryModule(maxItemsCount: 1)
//        let module = MediaLibraryItemsModule(maxItemsCount: 110)
//        let module = MediaItemCollectionsModule()
//        navigationController.viewControllers = [module.viewController]
        navigationController.viewControllers = [MainViewController()]
//        module.viewController.navigationController?.navigationBar.isHidden = true
        super.init(rootViewController: navigationController)
//        super.init(rootViewController: module.viewController)
    }

    func start(launchOptions: LaunchOptions?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
