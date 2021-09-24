//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools
import Framezilla
import MediaService

public final class MediaItemsViewController: UIViewController {

    private let presenter: MediaItemsPresenter

    private lazy var factory: MediaLibraryItemSectionsFactory = {
        let factory = MediaLibraryItemSectionsFactory(numberOfItemsInRow: presenter.numberOfItemsInRow)
        factory.output = presenter
        return factory
    }()

    private lazy var collectionViewManager: CollectionViewManager = {
        let manager = CollectionViewManager(collectionView: collectionView)
        manager.scrollDelegate = self
        return manager
    }()

    // MARK: - Subviews

    private lazy var placeholderView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    private lazy var permissionsPlaceholderView: PermissionsPlaceholderView = {
        let view = PermissionsPlaceholderView()
        view.title = L10n.MediaLibrary.Permissions.title
        view.subtitle = L10n.MediaLibrary.Permissions.subtitle
        view.isHidden = true
        return view
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = L10n.MediaLibrary.empty
        return label
    }()

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .gray
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    // MARK: - Lifecycle

    init(presenter: MediaItemsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.MediaLibrary.list
        view.addSubview(collectionView)
        placeholderView.addSubview(placeholderLabel)
        view.addSubview(placeholderView)
        view.addSubview(permissionsPlaceholderView)

        showMediaItemsPlaceholder()
        presenter.viewReadyEventTriggered()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        permissionsPlaceholderView.configureFrame { maker in
            maker.top()
            maker.left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        collectionView.configureFrame { maker in
            maker.edges(insets: view.safeAreaInsets)
        }

        permissionsPlaceholderView.configureFrame { maker in
            maker.top().left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        placeholderLabel.configureFrame { maker in
            maker.left().right()
            maker.centerY()
            maker.heightToFit()
        }
    }

    // MARK: -

    func showMediaItemsPlaceholder(estimatedItemCount: Int = 128) {
        collectionView.setContentOffset(.zero, animated: false)
        collectionView.isUserInteractionEnabled = false
        collectionViewManager.sectionItems = factory.placeholderSectionItems(placeholderCount: estimatedItemCount)

        placeholderView.isHidden = true
    }

    func update(with sectionItemsProvider: SectionItemsProvider, animated: Bool) {
        if animated {
            UIView.transition(with: collectionView, duration: 0.15, options: .transitionCrossDissolve, animations: {
                self.collectionViewManager.sectionItemsProvider = sectionItemsProvider
                self.collectionView.isUserInteractionEnabled = true
            }, completion: nil)
        }
        else {
            collectionViewManager.sectionItemsProvider = sectionItemsProvider
            collectionView.isUserInteractionEnabled = true
        }
        placeholderView.isHidden = sectionItemsProvider.numberOfSections != 0
    }

    public func select(items: [MediaItem]) {
        var items = items
        let sectionItemsDataSource = collectionViewManager.sectionItemsProvider
        for section in sectionItemsDataSource.sectionItems {
            for cellItem in section.cellItems {
                guard let baseCellItem = cellItem as? MediaItemCellItem,
                      let index = items.firstIndex(of: baseCellItem.viewModel.item) else {
                    continue
                }
                baseCellItem.viewModel.selectionIndex = index
                items.remove(at: index)
            }
        }
        collectionView.reloadData()
    }

    public func updateSelection(handler: (_ mediaItem: MediaItem) -> Int?) {
        let sectionItemsProvider = collectionViewManager.sectionItemsProvider
        for section in sectionItemsProvider.sectionItems {
            for cellItem in section.cellItems {
                if let baseCellItem = cellItem as? MediaItemCellItem {
                    baseCellItem.viewModel.selectionIndex = handler(baseCellItem.viewModel.item)
                }
            }
        }
        collectionView.reloadData()
    }

    func showMediaLibraryDeniedPermissionsPlaceholder() {
        permissionsPlaceholderView.isHidden = false
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
}

// MARK: - UIScrollViewDelegate

extension MediaItemsViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == -scrollView.contentInset.top {
            return presenter.scrollEventTriggered(direction: .down)
        }

        let delta = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let direction: MediaItemsPresenter.FocusDirection = (delta > 0.0) ? .down : .up
        presenter.scrollEventTriggered(direction: direction)
    }
}
