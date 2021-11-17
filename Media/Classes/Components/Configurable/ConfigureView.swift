//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import Foundation

public struct ConfigureView {
    public var backgroundColor: UIColor
    public var collectionViewBackgroundColor: UIColor
    public var configureCell: ConfigureCell
    public var configureSection: ConfigureSection

    public init(backgroundColor: UIColor = .black,
                collectionViewBackgroundColor: UIColor = .clear,
                configureCell: ConfigureCell = .init(),
                configureSection: ConfigureSection = .init()) {
        self.backgroundColor = backgroundColor
        self.collectionViewBackgroundColor = collectionViewBackgroundColor
        self.configureCell = configureCell
        self.configureSection = configureSection
    }
}
