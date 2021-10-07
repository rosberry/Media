//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class PhotoMediaItemCell: MediaItemCell {

    override func update(with viewModel: EmptyItemCellModel) {
        super.update(with: viewModel)

        if viewModel.mediaItem.type.isLivePhoto {
            typeImageView.image = Asset.icLivePhotoXs.image
            infoLabel.text = L10n.MediaLibrary.Item.live
        }
        else {
            typeImageView.image = nil
            infoLabel.text = nil
        }
    }
}
