//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Framezilla
import UIKit

class TitleImageView: UIView {

    var tapEventHandler: (() -> Void)?

    var innerInset: UIEdgeInsets = .init(top: 7, left: 10, bottom: 6, right: 6)
    private let betweenInset: CGFloat = 3

    private(set) lazy var titleLabel: UILabel = .init()

    private(set) lazy var imageView: UIImageView = .init()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.configureFrame { maker in
            maker.sizeToFit()
                 .right(inset: innerInset.right)
                 .centerY(to: titleLabel.nui_centerY)
        }

        titleLabel.configureFrame { maker in
            maker.top(inset: innerInset.top).bottom(inset: innerInset.bottom).left(inset: innerInset.left)
                 .right(to: imageView.nui_left, inset: betweenInset)
        }
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let imageViewSize = imageView.sizeThatFits(size)
        let titleSize = titleLabel.sizeThatFits(size)
        let width = titleSize.width + innerInset.horizontalSum + betweenInset + imageViewSize.width
        let height = max(imageViewSize.height, titleSize.height)
        return .init(width: width, height: height + innerInset.verticalSum)
    }

    private func setup() {
        addSubview(titleLabel)
        addSubview(imageView)
        isUserInteractionEnabled = true
        clipsToBounds = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selfPressed))
        addGestureRecognizer(tapGesture)
    }

    @objc private func selfPressed() {
        tapEventHandler?()
    }
}
