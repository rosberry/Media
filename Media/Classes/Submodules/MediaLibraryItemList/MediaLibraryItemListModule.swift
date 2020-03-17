//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

public protocol MediaLibraryItemListModuleInput: AnyObject {
    var collection: MediaItemCollection? { get set }

    var useStrictItemFiltering: Bool { get set }
    var filter: MediaItemFilter { get set }
    var selectedItems: [MediaItem] { get set }

    var fetchResult: MediaItemFetchResult? { get }
}

public protocol MediaLibraryItemListModuleOutput: AnyObject {
    func didFinishLoading(collection: MediaItemCollection, isMixedContentCollection: Bool)

    func didChangeFocusDirection(direction: MediaLibraryItemListPresenter.FocusDirection)
}

public final class MediaLibraryItemListModule {

    public var input: MediaLibraryItemListModuleInput {
        return presenter
    }

    public var output: MediaLibraryItemListModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: MediaLibraryItemListViewController
    private let presenter: MediaLibraryItemListPresenter

    public init(maxItemsCount: Int = 1, collection: MediaItemCollection? = nil) {
        presenter = MediaLibraryItemListPresenter(maxItemsCount: maxItemsCount, dependencies: Services)
        viewController = MediaLibraryItemListViewController(presenter: presenter)
        presenter.view = viewController
        input.collection = collection
    }
}
