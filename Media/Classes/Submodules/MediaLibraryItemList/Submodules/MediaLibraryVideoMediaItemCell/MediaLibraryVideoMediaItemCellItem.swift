//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import CollectionViewTools

final class MediaLibraryVideoMediaItemCellItem: MediaLibraryBaseMediaItemCellItem {
    typealias Cell = MediaLibraryVideoMediaItemCell

    override init(viewModel: MediaLibraryBaseMediaItemCellModel,
                  dependencies: Dependencies,
                  isSelectionInfoLabelHidden: Bool) {
        super.init(viewModel: viewModel, dependencies: dependencies, isSelectionInfoLabelHidden: isSelectionInfoLabelHidden)
        reuseType = ReuseType.class(Cell.self)
    }
}
