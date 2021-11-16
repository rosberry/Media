//
//  Copyright © 2018 Rosberry. All rights reserved.
//

import UIKit

final class DropdownButton: UIButton {

    private enum Constants {
        static let arrowLayerWidth: CGFloat = 24
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                arrowLayer.transform = CATransform3DMakeRotation(.pi, 0.0, 0.0, 1.0)
            }
            else {
                arrowLayer.transform = CATransform3DIdentity
            }
        }
    }

    var title: String? {
        get {
            title(for: .normal)
        }
        set {
            arrowLayer.isHidden = newValue == nil
            setTitleColor(UIColor.black, for: .normal)
            setTitle(newValue, for: .normal)
        }
    }

    // MARK: - Layer

    private lazy var arrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineCap = .round
        layer.lineJoin = .round
        layer.lineWidth = 2
        return layer
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentHorizontalAlignment = .left

        arrowLayer.isHidden = true
        layer.addSublayer(arrowLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let titleLabel = titleLabel else {
            return
        }

        titleLabel.configureFrame { maker in
            maker.left()
            maker.top().bottom()
            maker.widthThatFits(maxWidth: bounds.width - Constants.arrowLayerWidth)
        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)

        arrowLayer.bounds = CGRect(x: 0, y: 0, width: Constants.arrowLayerWidth, height: Constants.arrowLayerWidth)
        arrowLayer.position = CGPoint(x: titleLabel.frame.maxX + arrowLayer.bounds.midX, y: bounds.midY)

        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: 6.5, y: 9.5))
        arrowPath.addLine(to: CGPoint(x: arrowLayer.bounds.midX, y: arrowLayer.bounds.height - 9.5))
        arrowPath.addLine(to: CGPoint(x: arrowLayer.bounds.width - 6.5, y: 9.5))
        arrowLayer.path = arrowPath.cgPath

        CATransaction.commit()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let labelConstrainedSize = CGSize(width: size.width - Constants.arrowLayerWidth, height: size.height)
        let labelSize = titleLabel?.sizeThatFits(labelConstrainedSize) ?? labelConstrainedSize
        return CGSize(width: labelSize.width + Constants.arrowLayerWidth, height: size.height)
    }
}
