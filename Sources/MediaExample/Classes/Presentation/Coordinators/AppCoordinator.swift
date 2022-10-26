//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Media

final class AppCoordinator: BaseCoordinator<UIViewController> {

    var window: UIWindow?

    init() {
        let navigationController = UINavigationController()
        navigationController.viewControllers = [MainViewController()]
        super.init(rootViewController: navigationController)
    }

    func start(launchOptions: LaunchOptions?) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
}
