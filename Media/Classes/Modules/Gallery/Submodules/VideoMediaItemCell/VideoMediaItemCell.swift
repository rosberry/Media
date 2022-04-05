//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class VideoMediaItemCell: MediaItemCell {

    override func update(with viewModel: EmptyItemCellModel, cellAppearance: AssetCellAppearance) {
        super.update(with: viewModel, cellAppearance: cellAppearance)
        guard let duration = viewModel.mediaItem.duration else {
            return
        }

        let minutes = Int(duration / 60)
        let seconds = Int(duration) % 60
        infoLabel.attributedText = String(format: "%01d:%02d", minutes, seconds).text(with: .subtitle1B).attributed
        typeImageView.image = viewModel.mediaItem.type.isSloMoVideo ? Asset.icSloMoXs.image : nil
    }
}
