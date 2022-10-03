//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class PhotoMediaItemCell: MediaItemCell {

    override func update(with viewModel: EmptyItemCellModel, cellAppearance: AssetCellAppearance) {
        super.update(with: viewModel, cellAppearance: cellAppearance)

        if viewModel.mediaItem.type.isLivePhoto {
            typeImageView.image = Asset.ic16Livephoto.image.withRenderingMode(.alwaysTemplate)
            infoView.isHidden = true
        }
        else {
            typeImageView.image = nil
            infoLabel.text = nil
        }
    }
}
