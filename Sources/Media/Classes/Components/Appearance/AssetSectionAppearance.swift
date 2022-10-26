//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

public struct AssetSectionAppearance {
    public var minimumLineSpacing: CGFloat
    public var minimumInteritemSpacing: CGFloat
    public var numberOfItemsInRow: Int
    public var insets: UIEdgeInsets

    public init(minimumLineSpacing: CGFloat = 2,
                minimumInteritemSpacing: CGFloat = 1,
                numberOfItemsInRow: Int = 4,
                insets: UIEdgeInsets = .init(top: 1, left: 0.5, bottom: 1, right: 0.5)) {
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.numberOfItemsInRow = numberOfItemsInRow
        self.insets = insets
    }
}
