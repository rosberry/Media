//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class VideoMediaItemCell: MediaItemCell {

    override func update(with viewModel: EmptyItemCellModel, cellAppearance: AssetCellAppearance) {
        super.update(with: viewModel, cellAppearance: cellAppearance)
        cellAppearance.updateInfoLabelForVideoItem(cell: self, viewModel: viewModel)
    }
}
