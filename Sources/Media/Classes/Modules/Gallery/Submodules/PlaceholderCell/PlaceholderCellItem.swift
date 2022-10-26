//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

class PlaceholderCellItem: CollectionViewCellItem {

    typealias Cell = PlaceholderCell
    var reuseType = ReuseType.class(Cell.self)

    var appearance: AssetCellAppearance
    var sectionAppearance: AssetSectionAppearance

    init(appearance: AssetCellAppearance, sectionAppearance: AssetSectionAppearance) {
        self.appearance = appearance
        self.sectionAppearance = sectionAppearance
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        let width = (collectionView.bounds.width - sectionItem.insets.left - sectionItem.insets.right -
                     CGFloat(sectionAppearance.numberOfItemsInRow) * (sectionAppearance.minimumInteritemSpacing)) /
                     CGFloat(sectionAppearance.numberOfItemsInRow)
        return CGSize(width: width, height: width)
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }
        cell.cellAppearance = appearance
        appearance.update(cell: cell)
    }
}
