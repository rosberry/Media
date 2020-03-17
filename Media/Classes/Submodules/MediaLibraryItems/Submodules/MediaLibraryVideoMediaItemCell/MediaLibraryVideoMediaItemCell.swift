//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle

final class MediaLibraryVideoMediaItemCell: MediaLibraryBaseMediaItemCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Update

    override func update(with viewModel: MediaLibraryBaseMediaItemCellModel) {
        super.update(with: viewModel)
        guard let duration = viewModel.item.duration else {
            return
        }

        let minutes = Int(duration / 60)
        let seconds = Int(duration) % 60
        infoLabel.attributedText = Text(value: String(format: "%02d:%02d", minutes, seconds), style: .paragraph5).attributed
        typeImageView.image = viewModel.item.type.isSloMoVideo ? Asset.icSloMoXs.image : nil
    }
}
