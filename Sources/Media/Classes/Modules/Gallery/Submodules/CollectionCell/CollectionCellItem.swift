//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools
import MediaService

class CollectionCellItem: CollectionViewCellItem {
    typealias Cell = CollectionCell
    typealias Dependencies = HasMediaLibraryService

    private let viewModel: CollectionCellModel
    private let dependencies: Dependencies
    private let cellAppearance: AlbumCellAppearance
    var reuseType = ReuseType.class(Cell.self)

    init(viewModel: CollectionCellModel, dependencies: Dependencies, cellAppearance: AlbumCellAppearance) {
        self.viewModel = viewModel
        self.dependencies = dependencies
        self.cellAppearance = cellAppearance
    }

    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 88)
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }

        cell.update(with: viewModel, cellAppearance: cellAppearance)
        guard viewModel.thumbnail == nil else {
            return
        }

        let size = CGSize(width: 100.0, height: 100.0)
        dependencies.mediaLibraryService.fetchThumbnail(for: viewModel, size: size, contentMode: .aspectFill) { [weak self] (_: UIImage?) in
            guard let self = self else {
                return
            }

            cell.update(with: self.viewModel, cellAppearance: self.cellAppearance)
        }
    }
}
