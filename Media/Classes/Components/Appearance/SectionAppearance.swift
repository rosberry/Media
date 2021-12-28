//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct SectionAppearance {
    public var minimumLineSpacing: CGFloat
    public var minimumInteritemSpacing: CGFloat
    public var insets: UIEdgeInsets

    public init(minimumLineSpacing: CGFloat = 8.0,
                minimumInteritemSpacing: CGFloat = 8.0,
                insets: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)) {
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.insets = insets
    }
}
