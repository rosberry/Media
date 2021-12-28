//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import MediaService

public protocol CollectionsModuleInput: AnyObject {

    var collections: [MediaItemsCollection] { get set }

    func update(isAuthorized: Bool)
    func updateCollections()
}

public protocol CollectionsModuleOutput: AnyObject {

    func didSelect(_ collection: MediaItemsCollection)
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

    public init(collectionViewAppearance: CollectionViewAppearance) {
        presenter = CollectionsPresenter(dependencies: Services, collectionViewAppearance: collectionViewAppearance)
        viewController = CollectionsController(presenter: presenter)
        presenter.view = viewController
    }
}
