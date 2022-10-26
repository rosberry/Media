//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla
import Texstyle

public class CollectionCell: UICollectionViewCell {

    private var cellAppearance: AlbumCellAppearance = DefaultAlbumCellAppearance()

    override public var isHighlighted: Bool {
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

    override public func layoutSubviews() {
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

        cellAppearance.layout(cell: self)

        UIView.setAnimationsEnabled(true)
    }

    func update(with viewModel: CollectionCellModel, cellAppearance: AlbumCellAppearance) {
        self.cellAppearance = cellAppearance
        cellAppearance.update(cell: self, viewModel: viewModel)
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
