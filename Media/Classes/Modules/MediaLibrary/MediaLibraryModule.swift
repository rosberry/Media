//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import MediaService

public protocol MediaLibraryModuleInput: AnyObject {

    func update(isAuthorized: Bool)
    func select(_ collection: MediaItemsCollection)
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
                configurable: ConfigureView,
                collectionsModule: CollectionsModule,
                mediaItemsModule: MediaItemsModule,
                configureView: ConfigureView) {
        presenter = MediaLibraryPresenter(maxItemsCount: maxItemsCount,
                                          dependencies: Services,
                                          collectionsModule: collectionsModule,
                                          mediaItemsModule: mediaItemsModule,
                                          configureView: configureView)
        viewController = MediaLibraryViewController(presenter: presenter)
        presenter.view = viewController
    }
}
