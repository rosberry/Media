//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

class MediaLibraryBaseMediaItemCellItem: CollectionViewCellItem {
    typealias Cell = MediaLibraryBaseMediaItemCell
    typealias Dependencies = HasMediaLibraryService

    private var cell: Cell? {
        didSet {
            cell?.delegate = self
            cell?.update(with: viewModel)
        }
    }

    let viewModel: MediaLibraryBaseMediaItemCellModel
    private let dependencies: Dependencies
    var reuseType = ReuseType.class(Cell.self)

    var previewStartHandler: ((MediaLibraryBaseMediaItemCellModel, CGRect) -> Void)?
    var previewStopHandler: ((MediaLibraryBaseMediaItemCellModel) -> Void)?
    
    var isSelectionInfoLabelHidden: Bool

    init(viewModel: MediaLibraryBaseMediaItemCellModel,
         dependencies: Dependencies,
         isSelectionInfoLabelHidden: Bool) {
        self.viewModel = viewModel
        self.dependencies = dependencies
        self.isSelectionInfoLabelHidden = isSelectionInfoLabelHidden
    }

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
        guard let cell = cell as? Cell else {
            return
        }

        self.cell = cell

        guard viewModel.item.thumbnail == nil else {
            return
        }

        dependencies.mediaLibraryService.fetchThumbnail(for: viewModel.item) { [weak self] (_: UIImage?) in
            guard let self = self else {
                return
            }

            self.cell?.update(with: self.viewModel)
        }
        cell.selectionInfoLabel.isHidden = isSelectionInfoLabelHidden
    }

    func willDisplay(cell: UICollectionViewCell) {
        guard let cell = cell as? Cell else {
            return
        }

        self.cell = cell
    }

    func didEndDisplaying(cell: UICollectionViewCell) {
        self.cell = nil
    }
}

// MARK: - MediaLibraryBaseMediaItemCellDelegate

extension MediaLibraryBaseMediaItemCellItem: MediaLibraryBaseMediaItemCellDelegate {

    func didRequestPreviewStart(_ sender: UICollectionViewCell) {
        previewStartHandler?(viewModel, sender.frame)
    }

    func didRequsetPreviewStop(_ sender: UICollectionViewCell) {
        previewStopHandler?(viewModel)
    }
}
