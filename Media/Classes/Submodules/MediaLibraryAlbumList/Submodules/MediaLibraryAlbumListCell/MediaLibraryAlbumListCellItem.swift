//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

class MediaLibraryAlbumListCellItem: CollectionViewCellItem {
    typealias Cell = MediaLibraryAlbumListCell
    typealias Dependencies = HasMediaLibraryService

    private let viewModel: MediaLibraryAlbumListCellModel
    private let dependencies: Dependencies
    var reuseType = ReuseType.class(Cell.self)

    init(viewModel: MediaLibraryAlbumListCellModel, dependencies: Dependencies) {
        self.viewModel = viewModel
        self.dependencies = dependencies
    }

    func size() -> CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        return CGSize(width: collectionView.bounds.width, height: 72.0)
    }

    func configure(_ cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }

        cell.update(with: viewModel)
        guard viewModel.thumbnail == nil else {
            return
        }

        dependencies.mediaLibraryService.fetchThumbnail(for: viewModel) { [weak self] (_: UIImage?) in
            guard let self = self else {
                return
            }

            cell.update(with: self.viewModel)
        }
    }
}
