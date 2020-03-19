//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

public protocol MediaItemsModuleInput: AnyObject {

    var collection: MediaItemCollection? { get set }

    var numberOfItemsInRow: Int { get set }

    var filter: MediaItemFilter { get set }

    var selectedItems: [MediaItem] { get set }

    var fetchResult: MediaItemFetchResult? { get }

    func update(isAuthorized: Bool)
}

public protocol MediaItemsModuleOutput: AnyObject {
    func didStartPreview(item: MediaItem, from rect: CGRect)
    func didStopPreview(item: MediaItem)
    func didFinishLoading(_ collection: MediaItemCollection, isMixedContentCollection: Bool)
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

    public init(maxItemsCount: Int, numberOfItemsInRow: Int, collection: MediaItemCollection? = nil) {
        presenter = MediaItemsPresenter(maxItemsCount: maxItemsCount, numberOfItemsInRow: numberOfItemsInRow, dependencies: Services)
        viewController = MediaItemsViewController(presenter: presenter)
        presenter.view = viewController
        input.collection = collection
    }
}
