//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla
import MediaService

public final class MediaLibraryViewController: UIViewController {

    private let presenter: MediaLibraryPresenter

    private lazy var mediaItemsViewController = presenter.mediaItemsModule.viewController
    private lazy var collectionsViewController = presenter.collectionsModule.viewController

    public var isAuthorized: Bool = false {
        didSet {
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    private var isCollectionPickerVisible: Bool = false {
        didSet {
            collectionsViewController.view.isUserInteractionEnabled = isCollectionPickerVisible
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }

    // MARK: - Subviews

    private lazy var toolView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private lazy var albumSelectionButton: DropdownButton = {
        let button = DropdownButton(type: .custom)
        button.addTarget(self, action: #selector(albumSelectionButtonPressed), for: .touchUpInside)
        return button
    }()

    private lazy var filterView: SwitchView = {
        let view = SwitchView()
        view.items = MediaItemsFilter.allCases.map { filter in
            SwitchItem(title: filter.title.uppercased()) { [weak self] in
                self?.presenter.changeFilterEventTriggered(with: filter)
            }
        }
        return view
    }()

    // MARK: - Lifecycle

    init(presenter: MediaLibraryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.MediaLibrary.title.uppercased()
        view.backgroundColor = .gray

        toolView.addSubview(albumSelectionButton)
        toolView.addSubview(filterView)
        view.addSubview(toolView)

        add(child: mediaItemsViewController)
        add(child: collectionsViewController)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.MediaLibrary.done,
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(doneButtonPressed))

        presenter.viewReadyEventTriggered()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        toolView.configureFrame { (maker: Maker) in
            maker.top(inset: view.safeAreaInsets.top)
            maker.left().right()
            maker.height(38)
        }

        filterView.configureFrame { (maker: Maker) in
            maker.right(inset: 15.0)
            maker.centerY()
            maker.width(min(160.0, view.bounds.width * 0.45))
            maker.height(32.0)
        }

        albumSelectionButton.configureFrame { (maker: Maker) in
            maker.top().bottom()
            maker.left(inset: 16).right(inset: 16)
        }

        [mediaItemsViewController.view, collectionsViewController.view].configureFrames { maker in
            if isAuthorized {
                maker.top(to: toolView.nui_bottom)
            }
            else {
                maker.top(inset: view.safeAreaInsets.top)
            }
            maker.left().right()
        }

        mediaItemsViewController.view.configureFrame { maker in
            maker.bottom()
        }

        collectionsViewController.view.configureFrame { maker in
            if isCollectionPickerVisible {
                maker.bottom()
            }
            else {
                maker.height(0)
            }
        }
    }

    // MARK: - Private

    @objc private func albumSelectionButtonPressed() {
        albumSelectionButton.isSelected.toggle()
        updateCollectionPicker(isVisible: albumSelectionButton.isSelected)
    }

    @objc public func doneButtonPressed() {
        presenter.confirmationEventTriggered()
    }

    // MARK: -

    func setup(with collection: MediaItemsCollection, filter: MediaItemsFilter) {
        albumSelectionButton.title = collection.title?.uppercased()

        CATransaction.execute {
            CATransaction.setDisableActions(true)
            filterView.selectedIndex = filter.rawValue
        }
    }

    func updateCollectionPicker(isVisible: Bool) {
        albumSelectionButton.isSelected = isVisible
        collectionsViewController.beginAppearanceTransition(isVisible, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0.5, options: [], animations: {
            self.isCollectionPickerVisible = isVisible
        }, completion: { _ in
            self.collectionsViewController.endAppearanceTransition()
        })

        UIView.animate(withDuration: 0.15) {
            self.filterView.alpha = isVisible ? 0 : 1
        }
    }

    func showFilterSelector() {
        filterView.isHidden = false
    }

    func hideFilterSelector() {
        filterView.isHidden = true
    }
}
