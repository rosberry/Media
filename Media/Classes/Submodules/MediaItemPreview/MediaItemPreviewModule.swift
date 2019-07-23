//
//  Copyright © 2018 Rosberry. All rights reserved.
//

protocol MediaItemPreviewModuleInput: AnyObject {
    var mediaItem: MediaItem? { get set }
}

protocol MediaItemPreviewModuleOutput: AnyObject {
}

final class MediaItemPreviewModule {

    var input: MediaItemPreviewModuleInput {
        return presenter
    }
    var output: MediaItemPreviewModuleOutput? {
        get {
            return presenter.output
        }
        set {
            presenter.output = newValue
        }
    }
    let viewController: MediaItemPreviewViewController
    private let presenter: MediaItemPreviewPresenter

    init() {
        let dependencies = Services.sharedScope
        presenter = MediaItemPreviewPresenter(dependencies: dependencies)
        viewController = MediaItemPreviewViewController(presenter: presenter)
        presenter.view = viewController
    }
}
