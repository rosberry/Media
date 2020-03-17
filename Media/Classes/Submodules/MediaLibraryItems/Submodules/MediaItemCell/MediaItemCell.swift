//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit
import Framezilla

protocol MediaItemCellDelegate: AnyObject {
    func didRequestPreviewStart(_ sender: UICollectionViewCell)
    func didRequsetPreviewStop(_ sender: UICollectionViewCell)
}

class MediaItemCell: UICollectionViewCell {

    private lazy var longPressGestureRecognizer: UILongPressGestureRecognizer = {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(viewPressed))
        recognizer.minimumPressDuration = 1.0
        return recognizer
    }()
    
    weak var delegate: MediaItemCellDelegate?
    
    // MARK: - Subviews
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var infoView: UIView = {
        let view = UIView()
        view.backgroundColor = .main1
        return view
    }()
    
    private(set) lazy var infoLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private(set) lazy var typeImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        view.tintColor = .main2
        return view
    }()

    private lazy var selectionView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.main1.cgColor
        view.layer.borderWidth = 2.0
        view.layer.masksToBounds = true
        view.backgroundColor = .main2c
        view.alpha = 0.0
        return view
    }()

    private(set) lazy var selectionInfoLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .main1
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
        backgroundColor = .main4
        
        contentView.clipsToBounds = true
        contentView.addSubview(imageView)

        selectionView.addSubview(selectionInfoLabel)
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

        selectionInfoLabel.configureFrame { (maker: Maker) in
            maker.right().top()
            maker.width(28).height(28)
        }
        infoView.configureFrame { (maker: Maker) in
            maker.height(16).bottom()
        }
        typeImageView.configureFrame { (maker: Maker) in
            maker.left(inset: 2)
            maker.centerY()
            maker.sizeToFit()
        }
        infoLabel.configureFrame { (maker: Maker) in
            if typeImageView.image == nil {
                maker.left(inset: 4)
            }
            else {
                maker.left(to: typeImageView.nui_right)
            }
            maker.centerY(offset: -0.5)
            maker.sizeToFit()
        }
        infoView.configureFrame { (maker: Maker) in
            maker.width(infoLabel.frame.maxX + 4)
            maker.right()
        }
        infoView.isHidden = (infoLabel.text == nil) && (typeImageView.image == nil)
    }

    // MARK: - Actions

    @objc private func viewPressed() {
        if longPressGestureRecognizer.state == .began {
            delegate?.didRequestPreviewStart(self)
        }
        else if longPressGestureRecognizer.state != .changed {
            delegate?.didRequsetPreviewStop(self)
        }
    }

    // MARK: -

    func update(with viewModel: MediaItemCellModel) {
        imageView.image = viewModel.item.thumbnail
        if let selectionIndex = viewModel.selectionIndex {
            selectionView.alpha = 1.0
            selectionInfoLabel.text = "\(selectionIndex + 1)"
            imageView.layer.cornerRadius = selectionView.layer.cornerRadius
        }
        else {
            selectionView.alpha = 0.0
            selectionInfoLabel.text = nil
            imageView.layer.cornerRadius = 0.0
        }
        setNeedsLayout()
    }
}
