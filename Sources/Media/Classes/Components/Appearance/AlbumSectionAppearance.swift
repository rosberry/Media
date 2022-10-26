//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

public struct AlbumSectionAppearance {
    public var minimumLineSpacing: CGFloat
    public var minimumInteritemSpacing: CGFloat
    public var numberOfItemsInRow: Int
    public var cellHeight: CGFloat
    public var insets: UIEdgeInsets

    public init(minimumLineSpacing: CGFloat = 0,
                minimumInteritemSpacing: CGFloat = 0,
                numberOfItemsInRow: Int = 1,
                cellHeight: CGFloat = 88,
                insets: UIEdgeInsets = .init()) {
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.insets = insets
        self.numberOfItemsInRow = numberOfItemsInRow
        self.cellHeight = cellHeight
    }
}
