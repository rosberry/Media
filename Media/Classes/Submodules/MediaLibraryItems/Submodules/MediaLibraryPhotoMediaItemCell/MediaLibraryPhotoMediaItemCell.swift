//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class MediaLibraryPhotoMediaItemCell: MediaItemCell {

    override func update(with viewModel: MediaItemCellModel) {
        super.update(with: viewModel)

        if viewModel.item.type.isLivePhoto {
            typeImageView.image = Asset.icLivePhotoXs.image
            infoLabel.text = L10n.MediaLibrary.Item.live
        }
        else {
            typeImageView.image = nil
            infoLabel.text = nil
        }
    }
}
