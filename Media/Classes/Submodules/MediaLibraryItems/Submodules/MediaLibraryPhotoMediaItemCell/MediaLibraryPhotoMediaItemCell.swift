//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

final class MediaLibraryPhotoMediaItemCell: MediaLibraryBaseMediaItemCell {

    override func update(with viewModel: MediaLibraryBaseMediaItemCellModel) {
        super.update(with: viewModel)

        if viewModel.item.type.isLivePhoto {
            typeImageView.image = Asset.icLivePhotoXs.image
            infoLabel.attributedText = Text(value: L10n.MediaLibrary.Item.live, style: .paragraph5).attributed
        }
        else {
            typeImageView.image = nil
            infoLabel.text = nil
        }
    }
}
