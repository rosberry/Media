//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import UIKit

public final class PlaceholderCell: UICollectionViewCell {

    var cellAppearance: AssetCellAppearance = DefaultAssetCellAppearance()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        cellAppearance.layout(cell: self)
    }

    private func setup() {
        contentView.addSubview(imageView)
    }
}
