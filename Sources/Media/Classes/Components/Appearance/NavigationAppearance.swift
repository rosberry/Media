//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Texstyle
import UIKit
import MediaService

public struct NavigationAppearance {

    public enum Align {
        case left
        case center
        case right
    }

    public var titleStyle: TextStyle
    public var titleImage: UIImage?
    public var backImage: UIImage?
    public var cameraImage: UIImage?
    public var shouldShowBackButton: Bool = true
    public var shouldShowCameraButton: Bool = true
    public var filterAlign: Align = .right
    public var filter: [MediaItemsFilter] = []
    public var filterFormatter: (MediaItemsFilter) -> String = { $0.title }
    public var filterCustomizationHandler: ((SwitchView) -> Void)?
    public var titleAlign: Align = .center
    public var titleViewUpdateHandler: (AlbumTitleView) -> Void = { _ in }
    public var titleFormatter: (String) -> String = { $0 }

    public init(titleStyle: TextStyle = .title4A,
                titleImage: UIImage? = nil,
                backImage: UIImage? = nil,
                cameraImage: UIImage? = nil) {
        self.titleStyle = titleStyle
        self.titleImage = titleImage != nil ? titleImage : Asset.icShevroneDown24.image
        self.backImage = backImage != nil ? backImage : Asset.ic24Close.image
        self.cameraImage = cameraImage != nil ? cameraImage : Asset.ic24Camera.image
    }
}
