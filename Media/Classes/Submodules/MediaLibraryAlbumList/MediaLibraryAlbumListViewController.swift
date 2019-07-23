//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools
import Framezilla

public final class MediaLibraryAlbumListViewController: UIViewController {

    private let presenter: MediaLibraryAlbumListPresenter

    private lazy var collectionViewManager: CollectionViewManager = {
        return CollectionViewManager(collectionView: collectionView)
    }()
    
    // MARK: - Subviews
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .main4
        collectionView.alwaysBounceVertical = true
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private lazy var permissionsPlaceholderView: PermissionsPlaceholderView = {
        let view = PermissionsPlaceholderView()
        view.title = L10n.MediaLibrary.Permissions.title
        view.subtitle = L10n.MediaLibrary.Permissions.subtitle
        view.isHidden = true
        return view
    }()

    private lazy var factory: MediaLibraryAlbumListCellItemFactory = {
        let factory = MediaLibraryAlbumListCellItemFactory()
        factory.output = presenter
        return factory
    }()

    // MARK: - Lifecycle

    init(presenter: MediaLibraryAlbumListPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Albums"
        view.clipsToBounds = true
        view.addSubview(collectionView)
        view.addSubview(permissionsPlaceholderView)
        
        presenter.viewReadyEventTriggered()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        permissionsPlaceholderView.configureFrame { (maker: Maker) in
            maker.top()
            maker.left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        collectionView.configureFrame { maker in
            maker.edges(insets: view.safeAreaInsets)
        }
    }

    // MARK: -
    
    func showMediaLibraryDeniedPermissionsPlaceholder() {
        permissionsPlaceholderView.isHidden = false
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    func update(with mediaItemCollections: [MediaItemCollection]) {
        collectionView.contentOffset = .zero
        collectionViewManager.sectionItems = factory.sectionItems(for: mediaItemCollections)
        collectionView.isUserInteractionEnabled = true
    }
}
