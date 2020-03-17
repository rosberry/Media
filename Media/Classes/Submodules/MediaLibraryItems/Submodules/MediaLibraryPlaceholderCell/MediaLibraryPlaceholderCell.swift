//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

class MediaLibraryPlaceholderCell: UICollectionViewCell {

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.backgroundColor = UIColor.main3
    }
}
