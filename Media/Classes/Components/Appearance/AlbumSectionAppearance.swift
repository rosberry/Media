//
//  Copyright © 2022 Rosberry. All rights reserved.
//

public struct AlbumSectionAppearance {
    public var minimumLineSpacing: CGFloat
    public var minimumInteritemSpacing: CGFloat
    public var insets: UIEdgeInsets

    public init(minimumLineSpacing: CGFloat = 0,
                minimumInteritemSpacing: CGFloat = 0,
                insets: UIEdgeInsets = .init()) {
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.insets = insets
    }
}
