//
//  Copyright © 2019 Rosberry. All rights reserved.
//

import UIKit
import Media

final class MainViewController: UIViewController {

    private var coordinator: MediaCoordinator?

    // MARK: - Subviews

    private lazy var listButton: UIButton = {
        let button = UIButton()
        button.setTitle("Gallery", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(listButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [listButton])
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 8
        view.backgroundColor = .clear
        return view
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Menu"
        view.backgroundColor = .white
        view.addSubview(stackView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        stackView.configureFrame { maker in
            maker.size(width: 200, height: 166).center()
        }
    }

    @objc func listButtonPressed() {
        start()
    }

    private func start() {
        guard let navigationController = navigationController else {
            return
        }

        coordinator = .init(navigationViewController: navigationController)
        coordinator?.start(bundleName: "Whats Up")
    }
}
