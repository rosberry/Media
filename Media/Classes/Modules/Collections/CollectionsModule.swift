//
//  Copyright © 2018 Rosberry. All rights reserved.
//

public protocol CollectionsModuleInput: AnyObject {

    var collections: [MediaItemCollection] { get set }

    func update(isAuthorized: Bool)
    func updateCollections()
}

public protocol CollectionsModuleOutput: AnyObject {

    func didSelect(_ collection: MediaItemCollection)
}

public final class CollectionsModule {

    public var input: CollectionsModuleInput {
        return presenter
    }

    public var output: CollectionsModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: CollectionsController
    private let presenter: CollectionsPresenter

    public init() {
        presenter = CollectionsPresenter(dependencies: Services)
        viewController = CollectionsController(presenter: presenter)
        presenter.view = viewController
    }
}
