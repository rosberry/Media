//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

class PlaceholderCellItem: CollectionViewCellItem {

    typealias Cell = UICollectionViewCell
    var reuseType = ReuseType.class(Cell.self)

    var numberOfItemsInRow: Int = 4

    func size() -> CGSize {
        guard let collectionView = collectionView,
            let sectionItem = sectionItem else {
                return .zero
        }
        let width = (collectionView.bounds.width - sectionItem.insets.left - sectionItem.insets.right -
            CGFloat(numberOfItemsInRow) * (sectionItem.minimumInteritemSpacing)) / CGFloat(numberOfItemsInRow)
        return CGSize(width: width, height: width)
    }

    func configure(_ cell: UICollectionViewCell) {
        cell.contentView.backgroundColor = UIColor.main3
    }
}
