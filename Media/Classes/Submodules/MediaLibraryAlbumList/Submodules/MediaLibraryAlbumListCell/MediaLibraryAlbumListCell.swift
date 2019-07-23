//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Texstyle
import Framezilla

class MediaLibraryAlbumListCell: UICollectionViewCell {

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.contentView.backgroundColor = self.isHighlighted ? .main2 : .main4
            }
        }
    }

    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .main3
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var itemCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(itemCountLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        UIView.setAnimationsEnabled(false)

        imageView.layer.cornerRadius = 4.0
        imageView.configureFrame { (maker: Maker) in
            maker.left(inset: 15.0)
            maker.centerY()
            maker.size(width: contentView.bounds.height - 16.0, height: contentView.bounds.height - 16.0)
        }

        titleLabel.configureFrame { (maker: Maker) in
            maker.left(to: imageView.nui_right, inset: 15.0)
            maker.right(inset: 20.0)
            maker.bottom(to: imageView.nui_centerY, inset: 1.0)
            maker.heightToFit()
        }

        itemCountLabel.configureFrame { (maker: Maker) in
            maker.left(to: imageView.nui_right, inset: 15.0)
            maker.right(inset: 20.0)
            maker.top(to: imageView.nui_centerY, inset: 1.0)
            maker.heightToFit()
        }

        UIView.setAnimationsEnabled(true)
    }

    // MARK: -

    func update(with viewModel: MediaLibraryAlbumListCellModel) {
        imageView.image = viewModel.thumbnail
        titleLabel.attributedText = Text(value: viewModel.title ?? "", style: TextStyle.paragraph2.leftAligned()).attributed

        var itemCountLabelString: String?
        switch viewModel.estimatedMediaItemsCount {
        case .none:
            itemCountLabelString = L10n.MediaLibrary.unknown
        case .max?:
            if viewModel.isFavorite {
                itemCountLabelString = L10n.MediaLibrary.favoriteItems
            }
            else {
                itemCountLabelString = L10n.MediaLibrary.allItems
            }
        case .some(let count):
            itemCountLabelString = "\(count)"
        }
        itemCountLabel.attributedText = Text(value: itemCountLabelString, style: TextStyle.paragraph4.leftAligned())?.attributed
    }
}
