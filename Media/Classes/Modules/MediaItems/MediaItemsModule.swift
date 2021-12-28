//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import MediaService

public protocol MediaItemsModuleInput: AnyObject {

    var collection: MediaItemsCollection? { get set }

    var numberOfItemsInRow: Int { get set }

    var filter: MediaItemsFilter { get set }

    var selectedItems: [MediaItem] { get set }

    var fetchResult: MediaItemsFetchResult? { get }

    func update(isAuthorized: Bool)
}

public protocol MediaItemsModuleOutput: AnyObject {
    func didStartPreview(item: MediaItem, from rect: CGRect)
    func didStopPreview(item: MediaItem)
    func didFinishLoading(_ collection: MediaItemsCollection, isMixedContentCollection: Bool)
}

public final class MediaItemsModule {

    public var input: MediaItemsModuleInput {
        return presenter
    }

    public var output: MediaItemsModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: MediaItemsViewController
    private let presenter: MediaItemsPresenter

    public init(maxItemsCount: Int,
                numberOfItemsInRow: Int,
                collection: MediaItemsCollection? = nil,
                collectionAppearance: CollectionViewAppearance) {
        presenter = MediaItemsPresenter(maxItemsCount: maxItemsCount,
                                        numberOfItemsInRow: numberOfItemsInRow,
                                        dependencies: Services,
                                        collectionAppearance: collectionAppearance)
        viewController = MediaItemsViewController(presenter: presenter)
        presenter.view = viewController
        input.collection = collection
    }
}
