//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

class MediaItemCell: UICollectionViewCell {

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewPressed))
        recognizer.minimumPressDuration = 1.0
        return recognizer
    }()

    var didRequestPreviewStartHandler: ((UICollectionViewCell) -> Void)?
    var didRequestPreviewStopHandler: ((UICollectionViewCell) -> Void)?

    var modelIdentifier: String?

    private var configureCell: CellAppearance = .init()

    // MARK: - Subviews

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private(set) lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = configureCell.infoViewBackgroundColor
        view.alpha = CGFloat(configureCell.infoViewAlpha)
        view.layer.cornerRadius = CGFloat(configureCell.infoViewCornerRadius)
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()

    private(set) lazy var typeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.tintColor = .white
        return view
    }()

    private(set) lazy var selectionView: SelectionView = {
        let view = SelectionView(textColor: .white)
        view.alpha = 0.0
        return view
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
        backgroundColor = configureCell.contentViewColor

        contentView.layer.cornerRadius = CGFloat(configureCell.contentViewCornerRadius)
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)

        contentView.addSubview(selectionView)

        infoView.addSubview(infoLabel)
        infoView.addSubview(typeImageView)
        contentView.addSubview(infoView)

        contentView.isExclusiveTouch = true
        contentView.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = contentView.bounds
        selectionView.frame = contentView.bounds

        infoView.configureFrame { maker in
            maker.height(14).bottom(inset: 2)
        }
        typeImageView.configureFrame { maker in
            maker.left(inset: 2)
            maker.centerY()
            maker.sizeToFit()
        }
        infoLabel.configureFrame { maker in
            if typeImageView.image == nil {
                maker.left(inset: 4)
            }
            else {
                maker.left(to: typeImageView.nui_right)
            }
            maker.centerY(offset: -0.5)
            maker.sizeToFit()
        }
        infoView.configureFrame { maker in
            maker.width(infoLabel.frame.maxX + 4)
            maker.right(inset: 2)
        }
        infoView.isHidden = (infoLabel.text == nil) && (typeImageView.image == nil)
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

    func update(with viewModel: EmptyItemCellModel, configureCell: CellAppearance) {
        self.configureCell = configureCell
        imageView.image = viewModel.mediaItem.thumbnail
        if let selectionIndex = viewModel.selectionIndex {
            selectionView.alpha = 1.0
            selectionView.selectionInfoLabel.text = "\(selectionIndex + 1)"
            imageView.layer.cornerRadius = selectionView.layer.cornerRadius
        }
        else {
            selectionView.alpha = 0.0
            selectionView.selectionInfoLabel.text = nil
            imageView.layer.cornerRadius = 0.0
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
}
