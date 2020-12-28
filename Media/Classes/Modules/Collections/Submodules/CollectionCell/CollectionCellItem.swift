//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

class CollectionCellItem: CollectionViewCellItem {
    typealias Cell = CollectionCell
    typealias Dependencies = HasMediaLibraryService

    private let viewModel: CollectionCellModel
    private let dependencies: Dependencies
    var reuseType = ReuseType.class(Cell.self)

    init(viewModel: CollectionCellModel, dependencies: Dependencies) {
        self.viewModel = viewModel
        self.dependencies = dependencies
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 72)
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }

        cell.update(with: viewModel)
        guard viewModel.thumbnail == nil else {
            return
        }

        let size = CGSize(width: 100.0, height: 100.0)
        dependencies.mediaLibraryService.fetchThumbnail(for: viewModel, size: size, contentMode: .aspectFill) { [weak self] (_: UIImage?) in
            guard let self = self else {
                return
            }

            cell.update(with: self.viewModel)
        }
    }
}
