//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import MediaService

protocol MediaItemPreviewModuleInput: AnyObject {
    var mediaItem: MediaItem? { get set }
}

protocol MediaItemPreviewModuleOutput: AnyObject {
    func closeEventTriggered()
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
        presenter = MediaItemPreviewPresenter(dependencies: Services)
        viewController = MediaItemPreviewViewController(presenter: presenter)
        presenter.view = viewController
    }
}
