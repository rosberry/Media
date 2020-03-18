//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools
import Framezilla

public final class MediaLibraryItemsViewController: UIViewController {

    private let presenter: MediaLibraryItemsPresenter

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
        collectionView.backgroundColor = .main4
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    // MARK: - Lifecycle

    init(presenter: MediaLibraryItemsPresenter) {
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

        permissionsPlaceholderView.configureFrame { (maker: Maker) in
            maker.top()
            maker.left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        collectionView.frame = view.bounds

        permissionsPlaceholderView.configureFrame { (maker: Maker) in
            maker.top().left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        placeholderLabel.configureFrame { (maker: Maker) in
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
        collectionViewManager.dataSource = nil

        placeholderView.isHidden = true
    }

    func update(with dataSource: CollectionViewSectionDataSource, animated: Bool) {
        if animated {
            UIView.transition(with: collectionView, duration: 0.15, options: .transitionCrossDissolve, animations: {
                self.collectionViewManager.dataSource = dataSource
                self.collectionView.isUserInteractionEnabled = true
            }, completion: nil)
        }
        else {
            collectionViewManager.dataSource = dataSource
            collectionView.isUserInteractionEnabled = true
        }
        placeholderView.isHidden = dataSource.sectionCount != 0
    }

    public func select(items: [MediaItem]) {
        var items = items
        guard let sectionItemsDataSource = collectionViewManager.dataSource else {
            return
        }
        for sectionIndex in 0..<sectionItemsDataSource.sectionCount {
            guard let cellItemsDataSource = sectionItemsDataSource.itemDataSource(at: sectionIndex) else {
                continue
            }
            for cellIndex in 0..<cellItemsDataSource.itemCount {
                let cellItem = cellItemsDataSource.cellItem(at: cellIndex)
                if let baseCellItem = cellItem as? MediaItemCellItem {
                    if let index = items.firstIndex(of: baseCellItem.viewModel.item) {
                        baseCellItem.viewModel.selectionIndex = index
                        items.remove(at: index)
                    }
                }
            }
        }
        collectionView.reloadData()
    }

    public func updateSelection(handler: (_ mediaItem: MediaItem) -> (Int?)) {
        guard let sectionItemsDataSource = collectionViewManager.dataSource else {
            return
        }
        for sectionIndex in 0..<sectionItemsDataSource.sectionCount {
            guard let cellItemsDataSource = sectionItemsDataSource.itemDataSource(at: sectionIndex) else {
                continue
            }
            for cellIndex in 0..<cellItemsDataSource.itemCount {
                let cellItem = cellItemsDataSource.cellItem(at: cellIndex)
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

extension MediaLibraryItemsViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == -scrollView.contentInset.top {
            return presenter.scrollEventTriggered(direction: .down)
        }

        let delta = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let direction: MediaLibraryItemsPresenter.FocusDirection = (delta > 0.0) ? .down : .up
        presenter.scrollEventTriggered(direction: direction)
    }
}
