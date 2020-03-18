//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

public protocol MediaLibraryItemsModuleInput: AnyObject {

    var collection: MediaItemCollection? { get set }

    var numberOfItemsInRow: Int { get set }

    var useStrictItemFiltering: Bool { get set }
    var filter: MediaItemFilter { get set }
    var selectedItems: [MediaItem] { get set }

    var fetchResult: MediaItemFetchResult? { get }

    func update(isAuthorized: Bool)
}

public protocol MediaLibraryItemsModuleOutput: AnyObject {
    func didFinishLoading(_ collection: MediaItemCollection, isMixedContentCollection: Bool)
}

public final class MediaLibraryItemsModule {

    public var input: MediaLibraryItemsModuleInput {
        return presenter
    }

    public var output: MediaLibraryItemsModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: MediaLibraryItemsViewController
    private let presenter: MediaLibraryItemsPresenter

    public init(maxItemsCount: Int, numberOfItemsInRow: Int, collection: MediaItemCollection? = nil) {
        presenter = MediaLibraryItemsPresenter(maxItemsCount: maxItemsCount, numberOfItemsInRow: numberOfItemsInRow, dependencies: Services)
        viewController = MediaLibraryItemsViewController(presenter: presenter)
        presenter.view = viewController
        input.collection = collection
    }
}
