//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools
import Framezilla

public final class MediaItemCollectionsController: UIViewController {

    private let presenter: MediaItemCollectionsPresenter

    private lazy var collectionViewManager: CollectionViewManager = .init(collectionView: collectionView)

    private lazy var factory: MediaItemCollectionSectionsFactory = {
        let factory = MediaItemCollectionSectionsFactory()
        factory.output = presenter
        return factory
    }()

    // MARK: - Subviews

    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.main4
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

    // MARK: - Lifecycle

    init(presenter: MediaItemCollectionsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        title = L10n.MediaLibrary.albums
        view.clipsToBounds = true
        view.addSubview(collectionView)
        view.addSubview(permissionsPlaceholderView)

        presenter.viewReadyEventTriggered()
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        permissionsPlaceholderView.configureFrame { (maker: Maker) in
            maker.top().left().right()
            maker.bottom(inset: view.safeAreaInsets.bottom)
        }

        collectionView.frame = view.bounds
    }

    // MARK: -

    func showMediaLibraryDeniedPermissionsPlaceholder() {
        permissionsPlaceholderView.isHidden = false
    }

    func update(with mediaItemCollections: [MediaItemCollection]) {
        collectionView.contentOffset = .zero
        collectionViewManager.sectionItems = factory.makeSectionItems(mediaItemCollections: mediaItemCollections)
        collectionView.isUserInteractionEnabled = true
    }
}
