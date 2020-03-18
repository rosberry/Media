//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit
import Media

final class MainViewController: UIViewController {

    // MARK: - Subviews

    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setTitle("Main", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var albumButton: UIButton = {
        let button = UIButton()
        button.setTitle("Album", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(albumButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var listButton: UIButton = {
        let button = UIButton()
        button.setTitle("List", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(listButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.backgroundColor = .gray
        view.addSubview(containerView)
        containerView.addSubview(mainButton)
        containerView.addSubview(albumButton)
        containerView.addSubview(listButton)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        containerView.configureFrame { maker in
            maker.size(width: 200, height: 166).center()
        }

        mainButton.configureFrame { maker in
            maker.top().left().right().height(50)
        }

        albumButton.configureFrame { maker in
            maker.top(to: mainButton.nui_bottom, inset: 8).left().right().height(50)
        }

        listButton.configureFrame { maker in
            maker.top(to: albumButton.nui_bottom, inset: 8).left().right().height(50)
        }
    }

    // MARK: - Private

    @objc func albumButtonPressed() {
        let module = MediaItemCollectionsModule()
        self.navigationController?.pushViewController(module.viewController, animated: true)
    }

    @objc func listButtonPressed() {
        let module = MediaLibraryItemsModule(maxItemsCount: 2)
        self.navigationController?.pushViewController(module.viewController, animated: true)
    }

    @objc func mainButtonPressed() {
        let coordinator = MediaCoordinator(navigationViewController: navigationController!)
        coordinator.start()
    }
}
