//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

class MediaLibraryPlaceholderCellItem: CollectionViewCellItem {
    typealias Cell = MediaLibraryPlaceholderCell
    var reuseType = ReuseType.class(Cell.self)

    func size() -> CGSize {
        guard let collectionView = collectionView,
            let sectionItem = sectionItem else {
                return .zero
        }
        let numberOfItemsInRow: CGFloat = 4
        let width = (collectionView.bounds.width - sectionItem.insets.left - sectionItem.insets.right -
            numberOfItemsInRow * (sectionItem.minimumInteritemSpacing)) / numberOfItemsInRow
        return CGSize(width: width, height: width)
    }

    func configure(_ cell: UICollectionViewCell) {
        //
    }
}
