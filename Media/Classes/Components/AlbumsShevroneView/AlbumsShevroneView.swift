//
//  Copyright © 2022 Rosberry. All rights reserved.
//

import Foundation
import UIKit

public final class AlbumsShevroneView: UIView {

    public enum ShevronePosition {
        case up
        case down
    }

    var tapEventHandler: ((ShevronePosition) -> Void)?
    var innerInset: UIEdgeInsets = .init(top: 7, left: 10, bottom: 6, right: 6)

    public private(set) var state: ShevronePosition = .down
    public var betweenInset: CGFloat = 3
    public var imageOffset: CGFloat = 0
    private let titleImage: UIImage?

    private(set) lazy var titleLabel: UILabel = .init()

    private(set) lazy var imageView: UIImageView = .init()

    init(titleImage: UIImage?) {
        self.titleImage = titleImage
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.configureFrame { maker in
            maker.top(inset: innerInset.top).bottom(inset: innerInset.bottom)
        }

        imageView.configureFrame { maker in
            maker.sizeToFit()
                 .right(inset: innerInset.right)
                 .centerY(to: titleLabel.nui_centerY, offset: imageOffset)
        }

        titleLabel.configureFrame { maker in
            maker.right(to: imageView.nui_left, inset: betweenInset)
                 .left(inset: innerInset.left)
        }
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
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

        imageView.image = titleImage?.withRenderingMode(.alwaysOriginal)
        innerInset = 6

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selfPressed))
        addGestureRecognizer(tapGesture)
    }

    func update(shevronePosition: ShevronePosition) {
        guard state != shevronePosition else {
            return
        }
        let transform: CGAffineTransform
        switch shevronePosition {
        case .up:
            transform = .init(rotationAngle: CGFloat.pi)
        case .down:
            transform = .identity
        }
        state = shevronePosition
        UIView.animate(withDuration: 0.1) {
            self.imageView.transform = transform
        }
    }

    @objc private func selfPressed() {
        tapEventHandler?(state)
    }
}
