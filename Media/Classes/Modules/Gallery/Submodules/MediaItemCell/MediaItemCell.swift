//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

public class MediaItemCell: UICollectionViewCell {

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewPressed))
        recognizer.minimumPressDuration = 1.0
        return recognizer
    }()

    var didRequestPreviewStartHandler: ((UICollectionViewCell) -> Void)?
    var didRequestPreviewStopHandler: ((UICollectionViewCell) -> Void)?

    var modelIdentifier: String?

    private var cellAppearance: AssetCellAppearance = DefaultAssetCellAppearance()

    // MARK: - Subviews

    public private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    public private(set) lazy var infoView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()

    public private(set) lazy var infoLabel: UILabel = .init()

    public  private(set) lazy var typeImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        return view
    }()

    public private(set) var selectionView: UIView?

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.clipsToBounds = true

        contentView.addSubview(imageView)

        contentView.addSubview(typeImageView)

        infoView.addSubview(infoLabel)
        contentView.addSubview(infoView)

        contentView.isExclusiveTouch = true
        contentView.addGestureRecognizer(longPressGestureRecognizer)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = contentView.bounds
        selectionView?.frame = contentView.bounds

        infoView.configureFrame { maker in
            maker.height(18).bottom(inset: 2)
        }
        typeImageView.configureFrame { maker in
            maker.left(inset: 4)
            maker.top(inset: 4)
            maker.sizeToFit()
        }
        infoLabel.configureFrame { maker in
            maker.left(inset: 1.5)
            maker.centerY()
            maker.sizeToFit()
        }
        infoView.configureFrame { maker in
            maker.width(infoLabel.frame.maxX + 3)
            maker.right(inset: 2)
        }
        infoView.isHidden = (infoLabel.text == nil) && (typeImageView.image == nil)
        self.cellAppearance.layout(cell: self)
    }

    // MARK: - Actions

    @objc private func viewPressed() {
        if longPressGestureRecognizer.state == .began {
            didRequestPreviewStartHandler?(self)
        }
        else if longPressGestureRecognizer.state != .changed {
            didRequestPreviewStopHandler?(self)
        }
    }

    // MARK: -

    func update(with viewModel: EmptyItemCellModel, cellAppearance: AssetCellAppearance) {
        self.cellAppearance = cellAppearance
        if selectionView == nil {
            let selectionView = cellAppearance.selectionViewInitializer()
            contentView.addSubview(selectionView)
            self.selectionView = selectionView
        }
        imageView.image = viewModel.mediaItem.thumbnail
        cellAppearance.update(cell: self, viewModel: viewModel)
        setNeedsLayout()
        layoutIfNeeded()
    }
}
