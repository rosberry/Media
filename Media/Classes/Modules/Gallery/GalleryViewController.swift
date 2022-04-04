//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools
import Framezilla
import MediaService
import AVFoundation

public final class GalleryViewController: UIViewController {

    private typealias PhotoCellItem = UniversalCollectionViewCellItem<PhotoItemCellModel, PhotoMediaItemCell>
    private typealias VideoCellItem = UniversalCollectionViewCellItem<VideoItemCellModel, VideoMediaItemCell>

    private let presenter: GalleryPresenter

    private lazy var factory: GallerySectionsFactory = {
        let factory = GallerySectionsFactory(numberOfItemsInRow: presenter.numberOfItemsInRow,
                                                      dependencies: Services,
                                                      collectionAppearance: presenter.collectionAppearance)
        factory.output = presenter
        return factory
    }()

    private lazy var assetsCollectionManager: CollectionViewManager = {
        let manager = CollectionViewManager(collectionView: assetsCollectionView)
        manager.scrollDelegate = self
        return manager
    }()

    private lazy var albumsCollectionManager: CollectionViewManager = .init(collectionView: albumsCollectionView)

    // MARK: - Subviews

    private lazy var titleView: AlbumsShevroneView = {
        let view = AlbumsShevroneView()
        view.tapEventHandler = { [weak self] in
            self?.presenter.albumsEventTriggered()
        }
        return view
    }()

    private lazy var placeholderView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()

    private lazy var permissionsPlaceholderView: PermissionsPlaceholderView = {
        let view = PermissionsPlaceholderView()
        view.title = L10n.MediaLibrary.Permissions.title
        view.subtitle = L10n.MediaLibrary.Permissions.subtitle(presenter.bundleName)
        view.isHidden = true
        return view
    }()

    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = L10n.MediaLibrary.empty
        return label
    }()

    private(set) lazy var assetsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = presenter.collectionAppearance.collectionViewBackgroundColor
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()

    private(set) lazy var albumsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()

    // MARK: - Lifecycle

    init(presenter: GalleryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = presenter.collectionAppearance.backgroundColor
        view.addSubview(albumsCollectionView)
        view.addSubview(assetsCollectionView)
        placeholderView.addSubview(placeholderLabel)
        view.addSubview(placeholderView)
        view.addSubview(permissionsPlaceholderView)

        showMediaItemsPlaceholder()
        setupNavigationBar()
        presenter.viewReadyEventTriggered()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        permissionsPlaceholderView.configureFrame { maker in
            maker.top()
            maker.left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        assetsCollectionView.configureFrame { maker in
            maker.top(to: view.nui_safeArea.top).left().right().bottom()
        }

        albumsCollectionView.configureFrame { maker in
            maker.top(to: view.nui_safeArea.top).left().right().bottom()
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

    func changeCollectionView(assetsIsHidden: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.assetsCollectionView.frame.origin.y += assetsIsHidden ? self.view.frame.height : -self.view.frame.height
        }
    }

    func showMediaItemsPlaceholder(estimatedItemCount: Int = 128) {
        assetsCollectionView.setContentOffset(.zero, animated: false)
        assetsCollectionView.isUserInteractionEnabled = false
        assetsCollectionManager.sectionItems = factory.placeholderSectionItems(placeholderCount: estimatedItemCount)

        placeholderView.isHidden = true
    }

    func update(with mediaItemCollections: [MediaItemsCollection]) {
        albumsCollectionManager.sectionItems = factory.makeSectionItems(mediaItemCollections: mediaItemCollections)
        albumsCollectionView.isUserInteractionEnabled = true
    }

    func update(with sectionItemsProvider: LazySectionItemsProvider, animated: Bool) {
        if animated {
            UIView.transition(with: assetsCollectionView, duration: 0.15, options: .transitionCrossDissolve, animations: {
                self.assetsCollectionManager.mode = .lazy(provider: sectionItemsProvider)
                self.assetsCollectionView.isUserInteractionEnabled = true
                self.assetsCollectionView.reloadData()
            }, completion: nil)
        }
        else {
            self.assetsCollectionManager.mode = .lazy(provider: sectionItemsProvider)
            assetsCollectionView.isUserInteractionEnabled = true
            self.assetsCollectionView.reloadData()
        }
        placeholderView.isHidden = sectionItemsProvider.sectionItemsNumberHandler() != 0
    }

    public func select(items: [MediaItem]) {
        var items = items
        for section in assetsCollectionManager.sectionItems {
            for cellItem in section.cellItems {
                if let photoCellItem = cellItem as? PhotoCellItem,
                   let index = items.firstIndex(of: photoCellItem.object.mediaItem) {
                    photoCellItem.object.selectionIndex = index
                }
                else if let videoCellItem = cellItem as? VideoCellItem,
                        let index = items.firstIndex(of: videoCellItem.object.mediaItem) {
                    videoCellItem.object.selectionIndex = index
                    items.remove(at: index)
                }
            }
        }
    }

    public func updateSelection(handler: (_ mediaItem: MediaItem) -> Int?) {
        for section in assetsCollectionManager.sectionItems {
            for cellItem in section.cellItems {
                if let photoCellItem = cellItem as? PhotoCellItem {
                    photoCellItem.object.selectionIndex = handler(photoCellItem.object.mediaItem)
                    guard let cell = photoCellItem.cell as? MediaItemCell else {
                        return
                    }
                    cell.update(with: photoCellItem.object, cellAppearance: presenter.collectionAppearance.cellAppearance)
                }
                else if let videoCellItem = cellItem as? VideoCellItem {
                    videoCellItem.object.selectionIndex = handler(videoCellItem.object.mediaItem)
                    guard let cell = videoCellItem.cell as? MediaItemCell else {
                        return
                    }
                    cell.update(with: videoCellItem.object, cellAppearance: presenter.collectionAppearance.cellAppearance)
                }
            }
        }
    }

    func showMediaLibraryDeniedPermissionsPlaceholder() {
        permissionsPlaceholderView.isHidden = false
        navigationItem.titleView?.isHidden = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func updateTitleView(with title: String? = nil,
                         shevronePosition: AlbumsShevroneView.ShevronePosition) {
        if let title = title {
            titleView.titleLabel.attributedText = title.text(with: .title4A).attributed
            titleView.sizeToFit()
            titleView.setNeedsLayout()
            titleView.layoutIfNeeded()
        }

        titleView.update(shevronePosition: shevronePosition)
    }

    func updateTitleView(with shevronePosition: AlbumsShevroneView.ShevronePosition) {
        titleView.update(shevronePosition: shevronePosition)
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.view.backgroundColor = .white

        navigationItem.titleView = titleView
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.ic24Camera.image.withRenderingMode(.alwaysOriginal),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(cameraButtonPressed))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Asset.ic24Close.image.withRenderingMode(.alwaysOriginal),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(closeButtonPressed))
    }

    @objc private func cameraButtonPressed() {
        print(#function)
    }

    @objc private func closeButtonPressed() {
        presenter.closeEventTriggered()
    }
}

// MARK: - UIScrollViewDelegate

extension GalleryViewController: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == -scrollView.contentInset.top {
            return presenter.scrollEventTriggered(direction: .down)
        }

        let delta = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let direction: GalleryPresenter.FocusDirection = (delta > 0.0) ? .down : .up
        presenter.scrollEventTriggered(direction: direction)
    }
}
