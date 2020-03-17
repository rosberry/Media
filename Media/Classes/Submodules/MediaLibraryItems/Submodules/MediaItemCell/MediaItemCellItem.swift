//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

final class MediaItemCellItem<Cell: MediaItemCell>: CollectionViewCellItem {
    
    typealias Dependencies = HasMediaLibraryService

    private var cell: Cell? {
        didSet {
            cell?.delegate = self
            cell?.update(with: viewModel)
        }
    }

    let viewModel: MediaItemCellModel
    private let dependencies: Dependencies
    
    var reuseType: ReuseType {
        .class(Cell.self)
    }

    var previewStartHandler: ((MediaItemCellModel, CGRect) -> Void)?
    var previewStopHandler: ((MediaItemCellModel) -> Void)?
    
    var isSelectionInfoLabelHidden: Bool

    var numberOfItemsInRow: Int = 4

    init(viewModel: MediaItemCellModel,
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
        let width = (collectionView.bounds.width - sectionItem.insets.left - sectionItem.insets.right -
            CGFloat(numberOfItemsInRow) * (sectionItem.minimumInteritemSpacing)) / CGFloat(numberOfItemsInRow)
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

        dependencies.mediaLibraryService.fetchThumbnail(for: viewModel.item, size: CGSize(width: 100.0, height: 100.0)) { [weak self] (_: UIImage?) in
            guard let self = self else {
                return
            }

            self.cell?.update(with: self.viewModel)
        }
        cell.selectionView.selectionInfoLabel.isHidden = isSelectionInfoLabelHidden
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

// MARK: - MediaItemCellDelegate

extension MediaItemCellItem: MediaItemCellDelegate {

    func didRequestPreviewStart(_ sender: UICollectionViewCell) {
        previewStartHandler?(viewModel, sender.frame)
    }

    func didRequsetPreviewStop(_ sender: UICollectionViewCell) {
        previewStopHandler?(viewModel)
    }
}
