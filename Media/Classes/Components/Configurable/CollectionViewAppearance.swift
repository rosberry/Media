//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct CollectionViewAppearance {
    public var backgroundColor: UIColor
    public var collectionViewBackgroundColor: UIColor
    public var configureCell: CellAppearance
    public var configureSection: SectionAppearance

    public init(backgroundColor: UIColor = .black,
                collectionViewBackgroundColor: UIColor = .clear,
                configureCell: CellAppearance = .init(),
                configureSection: SectionAppearance = .init()) {
        self.backgroundColor = backgroundColor
        self.collectionViewBackgroundColor = collectionViewBackgroundColor
        self.configureCell = configureCell
        self.configureSection = configureSection
    }
}
