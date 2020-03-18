//
//  Copyright © 2018 Rosberry. All rights reserved.
//

public protocol MediaItemCollectionsModuleInput: AnyObject {

    var collections: [MediaItemCollection] { get set }

    func update(isAuthorized: Bool)
    func updateAlbumList()
}

public protocol MediaItemCollectionsModuleOutput: AnyObject {

    func didSelect(_ collection: MediaItemCollection)
}

public final class MediaItemCollectionsModule {

    public var input: MediaItemCollectionsModuleInput {
        return presenter
    }

    public var output: MediaItemCollectionsModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: MediaItemCollectionsController
    private let presenter: MediaItemCollectionsPresenter

    public init() {
        presenter = MediaItemCollectionsPresenter(dependencies: Services)
        viewController = MediaItemCollectionsController(presenter: presenter)
        presenter.view = viewController
    }
}
