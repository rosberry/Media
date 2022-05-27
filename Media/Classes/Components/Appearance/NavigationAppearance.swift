//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit.UIImage
import Texstyle
import UIKit

public struct NavigationAppearance {
    public var titleStyle: TextStyle
    public var titleImage: UIImage?
    public var backImage: UIImage?
    public var cameraImage: UIImage?
    public var shouldShowBackButton: Bool = true
    public var shouldShowCameraButton: Bool = true
    public var assetTitleViewHandler: (UIView) -> Void = { _ in }
    public var albumsTitleViewHandler: (UIView) -> Void = { _ in }
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
