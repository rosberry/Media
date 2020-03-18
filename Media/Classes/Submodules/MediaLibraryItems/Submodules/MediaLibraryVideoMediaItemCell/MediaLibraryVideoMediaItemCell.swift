//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class MediaLibraryVideoMediaItemCell: MediaItemCell {

    override func update(with viewModel: MediaItemCellModel) {
        super.update(with: viewModel)
        guard let duration = viewModel.item.duration else {
            return
        }

        let minutes = Int(duration / 60)
        let seconds = Int(duration) % 60
        infoLabel.text = String(format: "%02d:%02d", minutes, seconds)
        typeImageView.image = viewModel.item.type.isSloMoVideo ? Asset.icSloMoXs.image : nil
    }
}