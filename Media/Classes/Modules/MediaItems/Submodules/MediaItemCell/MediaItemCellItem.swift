//
//  Copyright © 2018 Rosberry. All rights reserved.
//

//import UIKit
//import CollectionViewTools
//import MediaService

//class MediaItemCellItem: CollectionViewCellItem {
//
//    typealias Cell = MediaItemCell
//    typealias Dependencies = HasMediaLibraryService
//
//    private var cell: Cell? {
//        didSet {
//            cell?.update(with: viewModel)
//        }
//    }
//
//    let viewModel: BaseItemCellModel
//    private let dependencies: Dependencies
//
//    var reuseType: ReuseType {
//        .class(Cell.self)
//    }
//
//    var previewStartHandler: ((BaseItemCellModel, CGRect) -> Void)?
//    var previewStopHandler: ((BaseItemCellModel) -> Void)?
//
//    var isSelectionInfoLabelHidden: Bool
//
//    let numberOfItemsInRow: Int
//
//    init(viewModel: BaseItemCellModel,
//         dependencies: Dependencies,
//         isSelectionInfoLabelHidden: Bool,
//         numberOfItemsInRow: Int) {
//        self.viewModel = viewModel
//        self.dependencies = dependencies
//        self.isSelectionInfoLabelHidden = isSelectionInfoLabelHidden
//        self.numberOfItemsInRow = numberOfItemsInRow
//    }
//
//    func size(in collectionView: UICollectionView, sectionItem: CollectionViewSectionItem) -> CGSize {
//        let width = (collectionView.bounds.width - sectionItem.insets.left - sectionItem.insets.right -
//                     CGFloat(numberOfItemsInRow) * (sectionItem.minimumInteritemSpacing)) / CGFloat(numberOfItemsInRow)
//        return CGSize(width: width, height: width)
//    }
//
//    func configure(_ cell: UICollectionViewCell) {
//        guard let cell = cell as? Cell else {
//            return
//        }
//
//        self.cell = cell
//
//        guard viewModel.mediaItem.thumbnail == nil else {
//            return
//        }
//
//        let size = CGSize(width: 100.0, height: 100.0)
//        dependencies.mediaLibraryService.fetchThumbnail(for: viewModel.mediaItem,
//                                                        size: size,
//                                                        contentMode: .aspectFill) { [weak self] (_: UIImage?) in
//            guard let self = self else {
//                return
//            }
//
//            self.cell?.update(with: self.viewModel)
//        }
//        cell.selectionView.selectionInfoLabel.isHidden = isSelectionInfoLabelHidden
//    }
//
//    func willDisplay(cell: UICollectionViewCell) {
//        guard let cell = cell as? Cell else {
//            return
//        }
//
//        self.cell = cell
//    }
//
//    func didEndDisplaying(cell: UICollectionViewCell) {
//        self.cell = nil
//    }
//}
