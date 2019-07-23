//
//  Copyright © 2018 Rosberry. All rights reserved.
//

public protocol MediaLibraryAlbumListModuleInput: AnyObject {

    var collections: [MediaItemCollection]? { get set }

    func updateAlbumList()
}

public protocol MediaLibraryAlbumListModuleOutput: AnyObject {
    func didSelect(collection: MediaItemCollection)
}

public final class MediaLibraryAlbumListModule {

    public var input: MediaLibraryAlbumListModuleInput {
        return presenter
    }

    public var output: MediaLibraryAlbumListModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: MediaLibraryAlbumListViewController
    private let presenter: MediaLibraryAlbumListPresenter

    public init() {
        let dependencies = Services.sharedScope
        presenter = MediaLibraryAlbumListPresenter(dependencies: dependencies)
        viewController = MediaLibraryAlbumListViewController(presenter: presenter)
        presenter.view = viewController
    }
}
