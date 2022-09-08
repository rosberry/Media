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

    private var cellAppearance: AssetCellAppearance = .init()

    // MARK: - Subviews

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private(set) lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = cellAppearance.infoViewBackgroundColor
        view.layer.cornerRadius = CGFloat(cellAppearance.infoViewCornerRadius)
        view.clipsToBounds = true
        return view
    }()

    private(set) lazy var infoLabel: UILabel = .init()

    private(set) lazy var typeImageView: UIImageView = {
        let view = UIImageView()
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
        contentView.backgroundColor = cellAppearance.contentViewColor
        contentView.layer.cornerRadius = CGFloat(cellAppearance.contentViewCornerRadius)
        contentView.clipsToBounds = true

        contentView.addSubview(imageView)

        contentView.addSubview(selectionView)

        contentView.addSubview(typeImageView)

        infoView.addSubview(infoLabel)
        contentView.addSubview(infoView)

        contentView.isExclusiveTouch = true
        contentView.addGestureRecognizer(longPressGestureRecognizer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = contentView.bounds
        selectionView.frame = contentView.bounds

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

        DispatchQueue.main.async {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
}
