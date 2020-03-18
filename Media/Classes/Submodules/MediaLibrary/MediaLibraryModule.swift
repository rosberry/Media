//
//  Copyright © 2018 Rosberry. All rights reserved.
//

public protocol MediaLibraryModuleInput: AnyObject {

    func select(_ collection: MediaItemCollection)
}

public protocol MediaLibraryModuleOutput: AnyObject {

    func mediaLibraryModuleDidFinish(_ moduleInput: MediaLibraryModuleInput, with items: [MediaItem])
}

public final class MediaLibraryModule {

    public var input: MediaLibraryModuleInput {
        return presenter
    }

    public var output: MediaLibraryModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }

    public let viewController: MediaLibraryViewController
    private let presenter: MediaLibraryPresenter

    public init(maxItemsCount: Int,
                mediaItemCollectionsModule: MediaItemCollectionsModule,
                mediaLibraryItemsModule: MediaLibraryItemsModule) {
        presenter = MediaLibraryPresenter(maxItemsCount: maxItemsCount,
                                          dependencies: Services,
                                          mediaItemCollectionsModule: mediaItemCollectionsModule,
                                          mediaLibraryItemsModule: mediaLibraryItemsModule)
        viewController = MediaLibraryViewController(presenter: presenter)
        presenter.view = viewController
    }
}
