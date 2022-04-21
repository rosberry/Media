//
//  Copyright © 2020 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

open class ATRButton: UIButton {

    open var touchRadiusInsets: UIEdgeInsets = 10

    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.inset(by: -touchRadiusInsets).contains(point)
    }

    public init() {
        super.init(frame: .zero)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
