//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct CollectionViewAppearance {
    public var backgroundColor: UIColor
    public var collectionViewBackgroundColor: UIColor
    public var cellAppearance: CellAppearance
    public var sectionAppearance: SectionAppearance

    public init(backgroundColor: UIColor = .white,
                collectionViewBackgroundColor: UIColor = .white,
                cellAppearance: CellAppearance = .init(),
                sectionAppearance: SectionAppearance = .init()) {
        self.backgroundColor = backgroundColor
        self.collectionViewBackgroundColor = collectionViewBackgroundColor
        self.cellAppearance = cellAppearance
        self.sectionAppearance = sectionAppearance
    }
}
