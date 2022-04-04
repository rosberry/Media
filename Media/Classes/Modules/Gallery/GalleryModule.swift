//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import MediaService

public protocol GalleryModuleInput: AnyObject {

    var collection: MediaItemsCollection? { get set }

    var numberOfItemsInRow: Int { get set }

    var filter: MediaItemsFilter { get set }

    var selectedItems: [MediaItem] { get set }

    var fetchResult: MediaItemsFetchResult? { get }

    func update(isAuthorized: Bool)
}

public protocol GalleryModuleOutput: AnyObject {
    func didStartPreview(item: MediaItem, from rect: CGRect)
    func didStopPreview(item: MediaItem)
    func didFinishLoading(_ collection: MediaItemsCollection, isMixedContentCollection: Bool)
    func closeEventTriggered()
}

public final class GalleryModule {

    public var input: GalleryModuleInput {
        return presenter
    }

    public var output: GalleryModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: GalleryViewController
    private let presenter: GalleryPresenter

    public init(bundleName: String,
                maxItemsCount: Int,
                numberOfItemsInRow: Int,
                collection: MediaItemsCollection? = nil,
                collectionAppearance: CollectionViewAppearance) {
        presenter = GalleryPresenter(bundleName: bundleName,
                                     maxItemsCount: maxItemsCount,
                                     numberOfItemsInRow: numberOfItemsInRow,
                                     dependencies: Services,
                                     collectionAppearance: collectionAppearance)
        viewController = GalleryViewController(presenter: presenter)
        presenter.view = viewController
        input.collection = collection
    }
}