//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla
import Texstyle

public class CollectionCell: UICollectionViewCell {

    private var cellAppearance: AlbumCellAppearance = DefaultAlbumCellAppearance()

    public override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.25) {
                self.cellAppearance.highlightChanged(cell: self, value: self.isHighlighted)
            }
        }
    }

    // MARK: - Subviews

    public private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public private(set) lazy var titleLabel: UILabel = .init()

    public private(set) lazy var itemCountLabel: UILabel = .init()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        UIView.setAnimationsEnabled(false)

        imageView.configureFrame { maker in
            maker.left(inset: 12.0)
            maker.centerY()
            maker.size(width: 72, height: 72)
        }

        titleLabel.configureFrame { maker in
            maker.left(to: imageView.nui_right, inset: 12.0)
            maker.right(inset: 18.0)
            maker.top(inset: 22.0)
            maker.heightToFit()
        }

        itemCountLabel.configureFrame { maker in
            maker.left(to: imageView.nui_right, inset: 12.0)
            maker.right(inset: 18.0)
            maker.top(to: titleLabel.nui_bottom, inset: 2)
            maker.heightToFit()
        }

        UIView.setAnimationsEnabled(true)
    }

    func update(with viewModel: CollectionCellModel, cellAppearance: AlbumCellAppearance) {
        self.cellAppearance = cellAppearance
        cellAppearance.update(cell: self, viewModel: viewModel)
        imageView.image = viewModel.thumbnail
        titleLabel.attributedText = viewModel.title?.text(with: cellAppearance.titleStyle).attributed

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
        itemCountLabel.attributedText = itemCountLabelString?.text(with: cellAppearance.subtitleStyle).attributed
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Private

    private func setup() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(itemCountLabel)
    }
}
